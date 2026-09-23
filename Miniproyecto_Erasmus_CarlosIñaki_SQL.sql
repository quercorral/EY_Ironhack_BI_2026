SELECT ROUND(AVG(TIMESTAMPDIFF(YEAR, s.dob, CURDATE())),2) AS edad_promedio

FROM students s

JOIN grades g

    ON s.student_id = g.student_id

WHERE g.grades >= 9;

SELECT

    student_id,

    subject_id,

    grades,

    CASE

        WHEN grades >= 9 THEN 'EXCELENTE'

        WHEN grades >= 7 THEN 'BUENO'

        WHEN grades >= 5 THEN 'APROBADO'

        ELSE 'REPROBADO'

    END AS categoria

FROM grades;

SELECT

    u.uni_name AS universidad,

    ROUND(AVG(TIMESTAMPDIFF(YEAR, s.dob, CURDATE())), 2) AS edad_media

FROM students s

JOIN campus c

    ON s.campus_id = c.campus_id

JOIN university u

    ON c.university_id = u.university_id

GROUP BY u.uni_name

ORDER BY edad_media DESC;

SELECT

    s.subj_name AS asignatura,

    COUNT(CASE WHEN g.grades < 5 THEN 1 END) AS alumnos_suspendidos,

    COUNT(*) AS total_alumnos,

    ROUND(

        COUNT(CASE WHEN g.grades < 5 THEN 1 END) * 100.0 /

        COUNT(*),

        2

    ) AS porcentaje_suspendidos

FROM grades g

JOIN subjects s

    ON g.subject_id = s.subject_id

GROUP BY s.subject_id, s.subj_name

ORDER BY porcentaje_suspendidos DESC;

SELECT

    CASE

        WHEN ia.student_id IS NOT NULL THEN 'Erasmus'

        ELSE 'No Erasmus'

    END AS tipo_estudiante,

    ROUND(AVG(g.grades),2) AS nota_media

FROM students s

JOIN grades g

    ON s.student_id = g.student_id

LEFT JOIN international_agreement ia

    ON s.student_id = ia.student_id

GROUP BY tipo_estudiante;

SELECT

    u.university_id,

    u.uni_name,

    COUNT(CASE WHEN b.bachelor_id LIKE 'B%' THEN 1 END) AS licenciaturas,

    COUNT(CASE WHEN b.bachelor_id LIKE 'M%' THEN 1 END) AS maestrias,

    COUNT(CASE WHEN b.bachelor_id LIKE 'D%' THEN 1 END) AS doctorados

FROM university u

LEFT JOIN bachelor b

    ON u.university_id = b.university_id

GROUP BY u.university_id, u.uni_name

ORDER BY u.university_id;

SELECT

    u.university_id,

    u.uni_name,

    ROUND(AVG(r.intl_ranking), 2) AS clasificacion_media

FROM university u

JOIN ranking r

    ON u.university_id = r.university_id

GROUP BY u.university_id, u.uni_name

ORDER BY clasificacion_media DESC

LIMIT 5;

SELECT

    s.student_id AS id_estudiante,

    s.f_name AS nombre,

    s.l_name AS apellidos,

    u.uni_name AS universidad_origen,

    s.email,

    COUNT(*) AS total_acuerdos

FROM international_agreement ia

JOIN students s

    ON ia.student_id = s.student_id

LEFT JOIN campus c

    ON s.campus_id = c.campus_id

LEFT JOIN university u

    ON c.university_id = u.university_id

GROUP BY

    s.student_id,

    s.f_name,

    s.l_name,

    u.uni_name,

    s.email

ORDER BY total_acuerdos DESC

LIMIT 10;

SELECT

    ia.agreement_code,

    s.student_id,

    CONCAT(s.f_name, ' ', s.l_name) AS estudiante,

    u.uni_name AS universidad_origen,

    c.city AS ciudad_intercambio

FROM international_agreement ia

JOIN students s

    ON ia.student_id = s.student_id

JOIN university u

    ON ia.home_university = u.university_id

JOIN campus c

    ON ia.away_university = c.university_id

WHERE ia.agreement_code = '123BH';

SELECT

    s.subject_id,

    s.subj_name AS asignatura,

    COUNT(DISTINCT us.university_id) AS numero_universidades,

    ROUND(AVG(g.grades), 2) AS nota_media

FROM subjects s

LEFT JOIN uni_subj us

    ON s.subject_id = us.subject_id

LEFT JOIN grades g

    ON s.subject_id = g.subject_id

GROUP BY

    s.subject_id,

    s.subj_name

ORDER BY numero_universidades DESC, nota_media DESC;

-- 10. Top 5 ciudades con mayor porcentaje de estudiantes con sobresalientes

 

SELECT

    s.city,

    s.state,

    ROUND(

        COUNT(CASE WHEN g.grades >= 9 THEN 1 END) * 100.0 /

        COUNT(*),

        2

    ) AS Percentage_Outstanding

FROM students s

JOIN grades g

    ON s.student_id = g.student_id

GROUP BY s.city, s.state

ORDER BY Percentage_Outstanding DESC

LIMIT 5;

 

-- 11. Universidades que envían más estudiantes

 

SELECT

    u.university_id,

    u.uni_name,

    COUNT(ia.student_id) AS estudiantes_enviados

FROM international_agreement ia

JOIN university u

    ON ia.home_university = u.university_id

GROUP BY u.university_id, u.uni_name

ORDER BY estudiantes_enviados DESC;

 

-- 11. Universidades que reciben más estudiantes

 

SELECT

    u.university_id,

    u.uni_name,

    COUNT(ia.student_id) AS estudiantes_recibidos

FROM international_agreement ia

JOIN university u

    ON ia.away_university = u.university_id

GROUP BY u.university_id, u.uni_name

ORDER BY estudiantes_recibidos DESC;

