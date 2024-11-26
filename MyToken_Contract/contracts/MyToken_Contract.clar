;; Define variables
(define-data-var token-name (string-ascii 32) "MyToken")
(define-data-var token-symbol (string-ascii 10) "MTK")
(define-data-var token-uri (optional (string-utf8 256)) none)
(define-data-var total-supply uint u0)

;; Define maps
(define-map balances principal uint)
(define-map allowances {owner: principal, spender: principal} uint)
(define-map metadata {token-id: uint} {name: (string-ascii 64), description: (string-utf8 256)})

;; Error constants
(define-constant err-owner-only (err u100))
(define-constant err-not-authorized (err u101))
(define-constant err-insufficient-balance (err u102))
(define-constant err-invalid-amount (err u103))

;; SIP-010 compliance functions
(define-public (transfer (amount uint) (sender principal) (recipient principal) (memo (optional (buff 34))))
    (begin
        (asserts! (is-eq tx-sender sender) err-not-authorized)
        (asserts! (>= (default-to u0 (get-balance sender)) amount) err-insufficient-balance)
        (try! (subtract-balance sender amount))
        (try! (add-balance recipient amount))
        (match memo to-print (print to-print) 0x)
        (ok true)))

;; Mint new tokens - restricted to contract owner
(define-public (mint (amount uint) (recipient principal))
    (begin
        (asserts! (is-eq tx-sender (contract-owner)) err-owner-only)
        (try! (add-balance recipient amount))
        (var-set total-supply (+ (var-get total-supply) amount))
        (ok true)))

;; Burn tokens
(define-public (burn (amount uint) (owner principal))
    (begin
        (asserts! (is-eq tx-sender owner) err-not-authorized)
        (asserts! (>= (default-to u0 (get-balance owner)) amount) err-insufficient-balance)
        (try! (subtract-balance owner amount))
        (var-set total-supply (- (var-get total-supply) amount))
        (ok true)))

;; Internal helper functions
(define-private (add-balance (account principal) (amount uint))
    (begin
        (map-set balances
            account
            (+ (default-to u0 (map-get? balances account)) amount))
        (ok true)))

(define-private (subtract-balance (account principal) (amount uint))
    (begin
        (map-set balances
            account
            (- (default-to u0 (map-get? balances account)) amount))
        (ok true)))

;; Read-only functions
(define-read-only (get-balance (account principal))
    (default-to u0 (map-get? balances account)))

(define-read-only (get-total-supply)
    (var-get total-supply))

(define-read-only (get-token-name)
    (var-get token-name))

(define-read-only (get-token-symbol)
    (var-get token-symbol))

;; Metadata management
(define-public (set-token-metadata (token-id uint) (name (string-ascii 64)) (description (string-utf8 256)))
    (begin
        (asserts! (is-eq tx-sender (contract-owner)) err-owner-only)
        (map-set metadata
            {token-id: token-id}
            {name: name, description: description})
        (ok true)))

(define-read-only (get-token-metadata (token-id uint))
    (map-get? metadata {token-id: token-id}))