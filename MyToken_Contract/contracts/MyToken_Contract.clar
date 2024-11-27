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
