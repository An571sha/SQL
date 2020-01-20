import java.io.*;
import java.sql.*;
import java.util.HashMap;

public class Dbsys {
    static final String LANDNAME = "landname";
    static final String MAILADRESSE = "mailadresse";

    static String name = null;
    static String passwd = null;

    static String land = "Spanien";
    static String startDatum = "01.11.2016";
    static String endDatum = "21.11.2016";
    static String ausstattung = "Sauna";
    static String email = "";

    static BufferedReader in = new BufferedReader(new InputStreamReader(System.in));

    static Connection conn = null;
    static Statement stmt = null;
    static ResultSet rset = null;

    static String adr_id;
    static String buchung_id;
    static String strasse = "";
    static String plz = "";
    static String hausnummer = "";
    static String ort = "";
    static String strassenr;
    static String landname = "";

    static String newsletter = "";
    static String passwort = "";
    static String kundname = "";
    static String iban = "";
    static String ferienwohnungsName = "";
    static String anDatum = "";
    static String abDatum = "";
    static String preis = "";

    static HashMap<String,Float> hashMapWithNameUndPreis =  new HashMap<String,Float>();


    public static void main(String[] args) {
        connectToSqlServer();
    }

    private static void connectToSqlServer() {
        try {
            name = "dbsys52";
            System.out.println("Executing:");
            passwd = "anijan";
        } catch (Exception e) {
            System.out.println("Fehler beim Lesen der Eingabe: " + e);
            System.exit(-1);
        }

        System.out.println("");

        try {
            DriverManager.registerDriver(new oracle.jdbc.OracleDriver());                // Treiber laden
            String url = "jdbc:oracle:thin:@oracle12c.in.htwg-konstanz.de:1521:ora12c"; // String für DB-Connection
            conn = DriverManager.getConnection(url, name, passwd);                        // Verbindung erstellen

            conn.setTransactionIsolation(Connection.TRANSACTION_SERIALIZABLE);            // Transaction Isolations-Level setzen
            conn.setAutoCommit(false);                                                    // Kein automatisches Commit
            stmt = conn.createStatement();

           rset = stmt.executeQuery(queryForFerienWohnung(startDatum, endDatum, ausstattung, land));
//         rset = stmt.executeQuery(testQuery());
           System.out.println(rset.toString());



            while (rset.next()) {

                System.out.println(rset.getString("name") + "----" + rset.getString("AVG(be.sterne)"));
                System.out.println();
            }


            System.out.println("please enter email addresse-");
            email = in.readLine();

            if(istEineNeueKunde(email,stmt)){

                System.out.println("We could not find you in our database please enter credentials - ");


                System.out.println("Newsletter-");
                newsletter = in.readLine();

                System.out.println("passwort-");
                passwort = in.readLine();

                System.out.println("Name-");
                kundname = in.readLine();

                System.out.println("iban-");
                iban = in.readLine();

                System.out.println("Strasse-");
                strasse = in.readLine();

                System.out.println("plz");
                plz = in.readLine();

                System.out.println("ort/city name-");
                ort = in.readLine();

                System.out.println("landname-");
                landname = in.readLine();

                System.out.println("hausnummer-");
                hausnummer = in.readLine();

                strassenr = strasse + hausnummer + plz;

                adr_id = String.valueOf(Math.abs(strassenr.hashCode()));

                registerNeueKunde(newsletter,passwort,kundname,iban,strasse,plz,ort,hausnummer,landname,stmt);

            }

            System.out.println("Welcome Back \n");
            showAlleFerienWohnungsName(stmt);
            System.out.println(" Please enter a Ferienwohnungsname - \n");

            ferienwohnungsName = in.readLine();

            if(hashMapWithNameUndPreis.containsKey(ferienwohnungsName)){


                System.out.println(" Please enter arrival date in  format dd.mm.yyyy - \n");
                anDatum = in.readLine();

                System.out.println(" Please enter departure date in  format dd.mm.yyyy - \n");
                abDatum = in.readLine();

                long dates = DateUtils.compareDates(anDatum,abDatum);
                float preisProTag = hashMapWithNameUndPreis.get(ferienwohnungsName);
                float summe = (dates * preisProTag);

                preis = String.valueOf((int)summe);

                System.out.println("total preis " + preis);

                int time = Long.hashCode(System.currentTimeMillis());

                if (time < 0) {
                    time = time * -1;
                    time = (time / 10000);
                } else {
                    time = time / 10000;
                }

                buchung_id = String.valueOf(time);
                System.out.println(buchung_id);

                stmt.executeQuery(insertIntoBuchung(buchung_id,anDatum,abDatum,ferienwohnungsName,email,preis));

                System.out.println(" Booking successful - \n");

            } else {

                System.out.println(" Please enter a Ferienwohnungsname from the list - \n");

            }


            conn.commit();
            conn.close();

        } catch (SQLException se) {                                                        // SQL-Fehler abfangen
            System.out.println();
            System.out.println("SQL Exception occurred while establishing connection to DBS: "
                            + se.getMessage());
            System.out.println("- SQL state  : " + se.getSQLState());
            System.out.println("- Message    : " + se.getMessage());
            System.out.println("- Vendor code: " + se.getErrorCode());
            System.out.println();
            System.out.println("EXITING WITH FAILURE ... !!!");
            System.out.println();
            try {
                conn.rollback();                                                        // Rollback durchführen
            } catch (SQLException e) {
                e.printStackTrace();
            }
            System.exit(-1);

        } catch (Exception e){
            e.printStackTrace();
        }
    }


    private static boolean istEineNeueKunde(String email, Statement statement) throws SQLException {

        ResultSet resultSet;
        resultSet = statement.executeQuery("SELECT mailadresse FROM dbsys51.Kunde ");

        while (resultSet.next()) {
            if (email.equals(resultSet.getString(MAILADRESSE))) {

                return false;
            }
        }
        return true;
    }

    private static boolean isteinNeuesLand(String name, Statement statement) {
        ResultSet resultSet;
        try {
            resultSet = statement.executeQuery("SELECT * FROM dbsys51.Land ");

            while (resultSet.next()) {

                if (name.equals(resultSet.getString("name"))){
                    System.out.println("land name was found in Databank");
                    return false;
                }

            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return true;
    }

    private static void registerNeueKunde(String newsletter, String passwort, String kundname, String iban, String strasse, String plz, String ort, String hausnummer, String landname,Statement statement) throws IOException, SQLException, InterruptedException {

/*
        if(isteinNeuesLand(landname,statement)){
            statement.executeQuery(insertIntoLand(landname));
        }
*/
        statement.executeQuery(insertIntoAdresse(adr_id,strasse,landname,plz,hausnummer,ort));
        Thread.sleep(2000);
        statement.executeQuery(insertIntoKunde(email,passwort,iban,kundname,adr_id));

        ResultSet rset = null;
    }

    private static void showAlleFerienWohnungsName(Statement statement) throws SQLException{
        ResultSet resultSet;
        resultSet = statement.executeQuery("SELECT name, preisprotag FROM dbsys51.Ferienwohnung ");

        while (resultSet.next()) {
            System.out.println( " Name - " + resultSet.getString("name") + "-----" +
                                    "Preis pro tag - "+resultSet.getFloat("preisprotag") + " ");
            hashMapWithNameUndPreis.put(resultSet.getString("name"),resultSet.getFloat("preisprotag"));
        }

        System.out.println("\n");
    }

    private static String insertIntoAdresse(String adr_id ,String strasse, String landname, String plz, String hausnummer, String ort){
        return "INSERT INTO Dbsys51.Adresse VALUES( " + adr_id + " ,'" + plz + "','" + strasse + "', '" + hausnummer + "', '" + landname + "','" + ort + "')";
    }

    private static String insertIntoLand(String land){
        return "INSERT INTO Dbsys51.Adresse VALUES('" + land + "')";
    }

    private static String insertIntoKunde (String email, String passwort, String iban, String kundname, String adr_id){
        return "INSERT INTO Dbsys51.Kunde VALUES('" + email + "', '" + passwort + "', '" + iban + "', '" + kundname + "','" + adr_id + "')";
    }

    private static String insertIntoBuchung(String time, String anDatum, String abDatum, String ferienwohnungsName, String email, String betrag){
        return "INSERT INTO Dbsys51.Buchung VALUES (" + time + ",to_date(sysdate, 'DD.MM.YYYY'),to_date('" + abDatum + "', 'DD.MM.YYYY'),to_date('" + anDatum + "', 'DD.MM.YYYY'),'" + ferienwohnungsName + "','" + email + "' ,'" + betrag + "', " + time + ", '', to_date(sysdate, 'DD.MM.YYYY'))";
    }

    private static String testQuery() {

        return "SELECT a.landname, NVL(COUNT(b.FERIENWOHNUNGSNAME), 0)\n" +
                "FROM DBSYS51.Buchung b INNER JOIN DBSYS51.Ferienwohnung f ON b.FERIENWOHNUNGSNAME = f.name \n" +
                "RIGHT OUTER JOIN DBSYS51.Adresse a ON a.addressid = f.addressid\n" +
                "GROUP BY a.landname\n" +
                "ORDER BY NVL(COUNT(b.buchungsnummer), 0) DESC";

    }

    private static String queryForFerienWohnung(String startDatum, String endDatum, String austtatung, String land) {

        if (!startDatum.isEmpty() && !endDatum.isEmpty() && !austtatung.isEmpty() && !land.isEmpty()) {

           return "SELECT f.name, AVG(be.sterne)\n" +
                    "FROM DBSYS51.ferienwohnung f, DBSYS51.buchung b, DBSYS51.adresse a, DBSYS51.Bewertung be\n" +
                    "WHERE\n" +
                    "    b.ferienwohnungsname = f.name AND\n" +
                    "    NOT EXISTS( \n" +
                    "                SELECT be.ferienwohnungsname\n" +
                    "                FROM DBSYS51.buchung be WHERE\n" +
                    "                (be.abreisedatum > to_date('"+endDatum+"', 'DD.MM.YYYY') AND be.anreisedatum < to_date('"+startDatum+"', 'DD.MM.YYYY'))\n" +
                    "                OR(be.anreisedatum > to_date('"+endDatum+"', 'DD.MM.YYYY') AND be.abreisedatum < to_date('"+startDatum+"', 'DD.MM.YYYY')))\n" +
                    "    AND f.addressId = a.addressId \n" +
                    "    AND a.landname = '"+land+"'\n" +
                    "    AND b.ferienwohnungsname IN (SELECT bes.ferienwohnungsname FROM DBSYS51.besitzt bes WHERE bes.austattungsname = '"+austtatung+"')\n" +
                    "    AND b.BEWERTUNGSID = be.BEWERTUNGSID\n" +
                    "GROUP BY f.name\n" +
                    "ORDER BY AVG(be.sterne) DESC";
        }

        return "LOL";
    }
}
