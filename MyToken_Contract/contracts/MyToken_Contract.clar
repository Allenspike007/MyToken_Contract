(define-data-var contract-owner principal tx-sender)
(define-data-var token-name (string-ascii 32) "MyToken")
(define-data-var token-symbol (string-ascii 10) "MTK")
(define-data-var token-uri (optional (string-utf8 256)) none)
(define-data-var total-supply uint u0)
(define-data-var decimals uint u6)
;; Contract owner getter
(define-read-only (get-contract-owner)
    (var-get contract-owner))

;; Contract owner setter
(define-public (set-contract-owner (new-owner principal))
    (begin
        (asserts! (is-eq tx-sender (var-get contract-owner)) (err u100))
        (var-set contract-owner new-owner)
        (ok true)))
(define-read-only (get-token-name)
    (ok (var-get token-name)))

(define-read-only (get-token-symbol)
    (ok (var-get token-symbol)))

(define-read-only (get-decimals)
    (ok (var-get decimals)))

(define-read-only (get-total-supply)
    (ok (var-get total-supply)))

(define-read-only (get-token-uri)
    (ok (var-get token-uri)))
;; Define maps
(define-map balances principal uint)

;; Get account balance
(define-read-only (get-balance (account principal))
    (ok (default-to u0 (map-get? balances account))))

;; Mint tokens (contract owner only)
(define-public (mint (amount uint) (recipient principal))
    (begin
        (asserts! (is-eq tx-sender (var-get contract-owner)) (err u100))
        (asserts! (> amount u0) (err u103))
        (let ((recipient-balance (default-to u0 (map-get? balances recipient))))
            (map-set balances recipient (+ recipient-balance amount))
            (var-set total-supply (+ (var-get total-supply) amount))
            (ok true))))
;; Transfer tokens
(define-public (transfer (amount uint) (sender principal) (recipient principal) (memo (optional (buff 34))))
    (begin
        (asserts! (is-eq tx-sender sender) (err u101))
        (let ((sender-balance (default-to u0 (map-get? balances sender))))
            (asserts! (>= sender-balance amount) (err u102))
            (map-set balances sender (- sender-balance amount))
            (map-set balances recipient (+ (default-to u0 (map-get? balances recipient)) amount))
            (match memo to-print (print to-print) 0x)
            (ok true))))

;; Burn tokens
(define-public (burn (amount uint) (owner principal))
    (begin
        (asserts! (is-eq tx-sender owner) (err u101))
        (let ((current-balance (default-to u0 (map-get? balances owner))))
            (asserts! (>= current-balance amount) (err u102))
            (map-set balances owner (- current-balance amount))
            (var-set total-supply (- (var-get total-supply) amount))
            (ok true))))
;; Define metadata map
(define-map metadata {token-id: uint} {name: (string-ascii 64), description: (string-utf8 256)})

;; Set metadata (contract owner only)
(define-public (set-token-metadata (token-id uint) (name (string-ascii 64)) (description (string-utf8 256)))
    (begin
        (asserts! (is-eq tx-sender (var-get contract-owner)) (err u100))
        (map-set metadata
            {token-id: token-id}
            {name: name, description: description})
        (ok true)))

;; Get metadata
(define-read-only (get-token-metadata (token-id uint))
    (map-get? metadata {token-id: token-id}))
