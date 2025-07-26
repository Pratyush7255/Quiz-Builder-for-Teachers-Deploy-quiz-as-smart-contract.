;; Quiz Builder Contract for Teachers

;; Define a map to store quiz data per teacher
(define-map quizzes
  { teacher: principal, quiz-id: uint }
  { question: (string-ascii 100), answer: (string-ascii 100) })

;; Define a map to store student answers
(define-map submissions
  { quiz-id: uint, student: principal }
  { submitted-answer: (string-ascii 100), is-correct: bool })

;; Function 1: Teacher creates a quiz
(define-public (create-quiz (quiz-id uint) (question (string-ascii 100)) (answer (string-ascii 100)))
  (begin
    (map-set quizzes
      { teacher: tx-sender, quiz-id: quiz-id }
      { question: question, answer: answer })
    (ok true)))

;; Function 2: Student submits an answer
(define-public (submit-answer (quiz-id uint) (teacher principal) (submitted-answer (string-ascii 100)))
  (let (
        (quiz (map-get? quizzes { teacher: teacher, quiz-id: quiz-id }))
       )
    (match quiz qdata
      (begin
        (map-set submissions
          { quiz-id: quiz-id, student: tx-sender }
          { submitted-answer: submitted-answer, is-correct: (is-eq submitted-answer (get answer qdata)) })
        (ok true))
      (err u404)))) ;; Quiz not found