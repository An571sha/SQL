import java.io.*;
import java.sql.*;

public class Dbsys {

    static String name = null;
    static String passwd = null;

    static String land = "Schweiz";
    static String startDatum = "1.01.2018";
    static String endDatum = "1.02.2019";
    static String ausstattung = "WLAN";
    static String email = "bon@webdesign.de";

    static BufferedReader in = new BufferedReader(new InputStreamReader(System.in));

    static Connection conn = null;
    static Statement stmt = null;
    static ResultSet rset = null;

    static String adr_id;
    static String strasse = "rokgutstr";
    static String plz = "233232";
    static String hausnummer = "51";
    static String ort = "Pongyang";
    static String strassenr;
    static String landname = "Korea";

    static String newsletter = "no";
    static String passwort = "1234567";
    static String kundname = "Bonasai";
    static String iban = "DC1221212221";


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

//            System.out.println(queryForFerienWohnung(startDatum, endDatum, ausstattung, land));
//          System.out.println(testQuery());
            rset = stmt.executeQuery(queryForFerienWohnung(startDatum, endDatum, ausstattung, land));
//          rset = stmt.executeQuery(testQuery());
            System.out.println(rset.toString());

            System.out.println("please enter email addresse");
  //          email = in.readLine();
            while (rset.next()) {

                System.out.println(rset.getString("landname"));
            }

            if(istEineNeueKunde(email,stmt)){

                System.out.println("We could not find you please enter credentials");
                registerNeueKunde(newsletter,passwort,kundname,iban,strasse,plz,ort,hausnummer,landname);

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

        } catch (IOException e){
            e.printStackTrace();
        }
    }

/*    public String queryViewWith(String startDatum, String endDatum){
        if(!startDatum.isEmpty() && !endDatum.isEmpty()){
            return "CREATE OR REPLACE VIEW queryWithDates AS SELECT f.name FROM dbsys51.buchung b INNER JOIN dbsys51.ferienwohnung f ON  b.ferienwohnugsname = f.name"
                    + "WHERE((b.anreiseDatum  <= '" + startDatum + "' AND b.anreiseDatum  >= '" + startDatum + "') OR (b.abreiseDatum  <= '" + endDatum + "' AND b.abreiseDatum  >= '" + endDatum + "') OR (b.anreiseDatum  <= '" + startDatum + "' AND b.anreiseDatum  >= '" + endDatum + "'))";
        }
        return "PLEASE ENTER A VALID DATE";
    }

    public String queryViewWithOrWithout(String austtatung, String land){
        if(!austtatung.isEmpty() && !land.isEmpty()){  // will probably use left join  on ferienwohnung with besitzt and addresse
                return "CREATE OR REPLACE VIEW queryViewWithOrWithout AS SELECT f.name FROM dbsys51.ferienwohnung f, dbsys51.Besitzt be, dbsys51.Adresse a ";
        }

        return "PLEASE SELECT A VALID Country or Features";
    }
*/

    private static String queryForFerienWohnung(String startDatum, String endDatum, String austtatung, String land) {

        if (!startDatum.isEmpty() && !endDatum.isEmpty() && !austtatung.isEmpty() && !land.isEmpty()) {

            // return "SELECT f.name, AVG(be.sterne) FROM DBSYS51.ferienwohnung f, DBSYS51.buchung b, DBSYS51.adresse a, DBSYS51.Bewertung be WHERE b.ferienwohnungsname = f.name AND NOT EXISTS( SELECT be.ferienwohnungsname FROM DBSYS51.buchung be WHERE (be.abreisedatum > ' " + endDatum + " '  AND be.anreisedatum < ' " + startDatum + " ')\n" +
            //         " OR(be.anreisedatum > '" + endDatum + "' AND be.abreisedatum < '" + startDatum + "')) AND f.addressId = a.addressId AND a.landname = ' " + land + " ' AND b.ferienwohnungsname IN (SELECT bes.ferienwohnungsname FROM DBSYS51.besitzt bes WHERE bes.austattungsname = ' " + austtatung +" ')AND b.BEWERTUNGSID = be.BEWERTUNGSID GROUP BY f.name ORDER BY AVG(be.sterne) DESC";

            return "SELECT f.name, AVG(be.sterne) FROM DBSYS51.ferienwohnung f, DBSYS51.buchung b, DBSYS51.adresse a, DBSYS51.Bewertung be WHERE b.ferienwohnungsname = f.name AND NOT EXISTS( SELECT be.ferienwohnungsname FROM DBSYS51.buchung be WHERE ((b.anreiseDatum  <= '" + startDatum + "' AND b.anreiseDatum  >= '" + startDatum + "') OR (b.abreiseDatum  <= '" + endDatum + "' AND b.abreiseDatum  >= '" + endDatum + "') OR (b.anreiseDatum  <= '" + startDatum + "' AND b.anreiseDatum  >= '" + endDatum + "'))) AND f.addressId = a.addressId AND a.landname = ' " + land + " ' AND b.ferienwohnungsname IN (SELECT bes.ferienwohnungsname FROM DBSYS51.besitzt bes WHERE bes.austattungsname = ' " + austtatung + " ')AND b.BEWERTUNGSID = be.BEWERTUNGSID GROUP BY f.name ORDER BY AVG(be.sterne) DESC";


        }

        return "LOL";
    }

    private static String testQuery() {

        return "SELECT a.landname, NVL(COUNT(b.FERIENWOHNUNGSNAME), 0)\n" +
                "FROM DBSYS51.Buchung b INNER JOIN DBSYS51.Ferienwohnung f ON b.FERIENWOHNUNGSNAME = f.name \n" +
                "RIGHT OUTER JOIN DBSYS51.Adresse a ON a.addressid = f.addressid\n" +
                "GROUP BY a.landname\n" +
                "ORDER BY NVL(COUNT(b.buchungsnummer), 0) DESC";

    }

    private static boolean istEineNeueKunde(String email, Statement statement) throws SQLException {

        ResultSet resultSet;
        resultSet = statement.executeQuery("SELECT mailadresse FROM dbsys51.Kunde ");

        while (resultSet.next()) {
            if (email.equals(resultSet.getString("mailadresse"))) {

                return false;
            }
        }
        return true;
    }

    private static void registerNeueKunde(String newsletter, String passwort, String kundname, String iban, String strasse, String plz, String ort, String hausnummer, String landname) throws IOException, SQLException {
        System.out.println("Newsletter??????");
   //     newsletter = in.readLine();

        System.out.println("passwort-");
   //     passwort = in.readLine();

        System.out.println("Name-");
   //     kundname = in.readLine();

        System.out.println("iban-");
   //     iban = in.readLine();

        System.out.println("Strasse-");
   //     strasse = in.readLine();

        System.out.println("plz");
   //     plz = in.readLine();

        System.out.println("ort/city name-");
   //     ort = in.readLine();

        System.out.println("landname-");
   //     landname = in.readLine();

        System.out.println("hausnummer-");
   //     hausnummer = in.readLine();

        strassenr = strasse + hausnummer + plz;

        adr_id = String.valueOf(strassenr.hashCode());

        ResultSet rset = null;

        //do something with newsletter

        stmt.executeQuery("INSERT INTO Dbsys51.Adresse(addressid,postleitzahl,straße,hausnummer,landname,ort) VALUES(" + 56 + ", " + 9898 + "," + strasse + "," + 21 + "," + landname + "," + ort + ")");
     //   stmt.executeQuery("INSERT INTO dbsys51.Kunde VALUES(" + email + "," + passwort + "," + iban + "," + kundname + ","+ adr_id + ")");



    }
}
