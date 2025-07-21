VIEWS_DICT = {
    "Q3":
        [
            """
    CREATE VIEW ContactPopularity AS
    SELECT savedContact AS contact, COUNT(contactSaver) AS popularity
    FROM CommonContacts
    GROUP BY savedContact;
            """,
            """
            CREATE VIEW PersonWithMultipleCities AS
    SELECT contactSaver AS multipleCities
    FROM CommonContacts c1
             JOIN Contacts c2 ON c1.savedContact = c2.name
             JOIN Contacts c3 ON c1.contactSaver = c3.name
    WHERE c2.city != c3.city
    GROUP BY contactSaver
    HAVING COUNT(DISTINCT c2.city) >= 2;
            """,
            """
                CREATE VIEW PersonWithMutualContacts AS
    SELECT c1.contactSaver AS mutualContact
    FROM CommonContacts c1
             JOIN CommonContacts c2 ON c1.savedContact = c2.contactSaver
    WHERE c1.contactSaver = c2.savedContact
    GROUP BY c1.contactSaver
    HAVING COUNT(c1.savedContact) = COUNT(c2.savedContact);
            """,
            """
    CREATE VIEW PopularPersons AS
    SELECT mp.multipleCities AS popular
    FROM PersonWithMultipleCities mp
             JOIN (SELECT contactSaver,
                          MAX(cp.popularity) AS maxPopularity
                   FROM CommonContacts cc
                            JOIN
                        ContactPopularity cp ON cc.savedContact = cp.contact
                   GROUP BY contactSaver
                 ) AS mpop
         ON mpop.contactSaver = mp.multipleCities
    JOIN PersonWithMutualContacts mc ON mp.multipleCities = mc.mutualContact
    JOIN ContactPopularity cp ON mp.multipleCities = cp.contact
    WHERE cp.popularity >= mpop.maxPopularity;
    """
        ]
    ,
    "Q4":
        [
            """
           CREATE VIEW orgenized AS
               SELECT *
               FROM (SELECT DISTINCT con.name AS notLate
                    FROM Contacts con
                    WHERE con.name NOT IN (SELECT att1.contactName
                         FROM Attendance att1
                         WHERE att1.delay > 50)) AS notLate
               WHERE notLate NOT IN (
                   SELECT DISTINCT comm.contactSaver
                   FROM CommonContacts comm
                   WHERE comm.savedContact != comm.nickname
               );
                    """,
            """
            CREATE VIEW orgmeetings AS
SELECT att.date
FROM Attendance att
INNER JOIN orgenized org
ON att.contactName = org.notLate;
                    """,
            """
           CREATE VIEW friendlyCities AS
                SELECT DISTINCT c.city, c.name
                FROM Contacts c
    WHERE c.city NOT IN(SELECT DISTINCT c1.city
                    FROM Contacts c1,Contacts c2
                    WHERE c1.city = c2.city
                    AND c1.name != c2.name
                    AND NOT EXISTS (
                    SELECT *
                    FROM CommonContacts cmn
                    WHERE cmn.contactSaver = c1.name
                    AND cmn.savedContact = c2.name))
            ;

                    """,
            """
    CREATE VIEW minAtt AS
        SELECT contactName, min(date) AS mindate
        FROM Attendance
        GROUP BY contactName ;
            """
        ]
}
