QUERY_ANSWERS = {
    "Q3":
        """
        SELECT DISTINCT a.date
FROM Attendance a
JOIN PopularPersons p ON a.contactName = p.popular
ORDER BY a.date ASC;
        """
    ,
    "Q4":
        """
     SELECT DISTINCT frc.name, ma.mindate
FROM friendlyCities frc INNER JOIN Attendance att ON frc.name = att.contactName
INNER JOIN minAtt ma ON att.contactName = ma.contactName
INNER JOIN orgmeetings om ON om.date = att.date;
        """
}
