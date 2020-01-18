import java.io.*;
import java.sql.*;
import java.util.HashMap;

public class Dbsys {
    static final String LANDNAME = "landname";
    static final String MAILADRESSE = "mailadresse";

    static String name = null;
    static String passwd = null;

    static String land = "Schweiz";
    static String startDatum = "1.01.2018";
    static String endDatum = "1.02.2019";
    static String ausstattung = "WLAN";
    static String email = "";

    static BufferedReader in = new BufferedReader(new InputStreamReader(System.in));

    static Connection conn = null;
    static Statement stmt = null;
    static ResultSet rset = null;

    static String adr_id;
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

//          System.out.println(queryForFerienWohnung(startDatum, endDatum, ausstattung, land));
//          System.out.println(testQuery());
            rset = stmt.executeQuery(queryForFerienWohnung(startDatum, endDatum, ausstattung, land));
//          rset = stmt.executeQuery(testQuery());
            System.out.println(rset.toString());

            System.out.println("please enter email addresse-");
            email = in.readLine();

            while (rset.next()) {

                System.out.println(rset.getString(LANDNAME));
            }

            if(istEineNeueKunde(email,stmt)){

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

                System.out.println("We could not find you in our database please enter credentials - ");

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

                preis = String.valueOf(summe);

                System.out.println("total preis " + preis);


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

        } catch (IOException | InterruptedException e){
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
            resultSet = statement.executeQuery("SELECT name FROM dbsys51.Land ");

            while (resultSet.next()) {

                if (landname.equals(resultSet.getString("name"))){
                    System.out.println("land name was found in Databank");
                    return false;
                }

            }

        } catch (SQLException e) {
         //   System.out.println("i refuse to run because i am an idiot");
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

    private static String testQuery() {

        return "SELECT a.landname, NVL(COUNT(b.FERIENWOHNUNGSNAME), 0)\n" +
                "FROM DBSYS51.Buchung b INNER JOIN DBSYS51.Ferienwohnung f ON b.FERIENWOHNUNGSNAME = f.name \n" +
                "RIGHT OUTER JOIN DBSYS51.Adresse a ON a.addressid = f.addressid\n" +
                "GROUP BY a.landname\n" +
                "ORDER BY NVL(COUNT(b.buchungsnummer), 0) DESC";

    }

    private static String queryForFerienWohnung(String startDatum, String endDatum, String austtatung, String land) {

        if (!startDatum.isEmpty() && !endDatum.isEmpty() && !austtatung.isEmpty() && !land.isEmpty()) {

            // return "SELECT f.name, AVG(be.sterne) FROM DBSYS51.ferienwohnung f, DBSYS51.buchung b, DBSYS51.adresse a, DBSYS51.Bewertung be WHERE b.ferienwohnungsname = f.name AND NOT EXISTS( SELECT be.ferienwohnungsname FROM DBSYS51.buchung be WHERE (be.abreisedatum > ' " + endDatum + " '  AND be.anreisedatum < ' " + startDatum + " ')\n" +
            //         " OR(be.anreisedatum > '" + endDatum + "' AND be.abreisedatum < '" + startDatum + "')) AND f.addressId = a.addressId AND a.landname = ' " + land + " ' AND b.ferienwohnungsname IN (SELECT bes.ferienwohnungsname FROM DBSYS51.besitzt bes WHERE bes.austattungsname = ' " + austtatung +" ')AND b.BEWERTUNGSID = be.BEWERTUNGSID GROUP BY f.name ORDER BY AVG(be.sterne) DESC";

            return "SELECT f.name, AVG(be.sterne) FROM DBSYS51.ferienwohnung f, DBSYS51.buchung b, DBSYS51.adresse a, DBSYS51.Bewertung be WHERE b.ferienwohnungsname = f.name AND NOT EXISTS( SELECT be.ferienwohnungsname FROM DBSYS51.buchung be WHERE ((b.anreiseDatum  <= '" + startDatum + "' AND b.anreiseDatum  >= '" + startDatum + "') OR (b.abreiseDatum  <= '" + endDatum + "' AND b.abreiseDatum  >= '" + endDatum + "') OR (b.anreiseDatum  <= '" + startDatum + "' AND b.anreiseDatum  >= '" + endDatum + "'))) AND f.addressId = a.addressId AND a.landname = ' " + land + " ' AND b.ferienwohnungsname IN (SELECT bes.ferienwohnungsname FROM DBSYS51.besitzt bes WHERE bes.austattungsname = ' " + austtatung + " ')AND b.BEWERTUNGSID = be.BEWERTUNGSID GROUP BY f.name ORDER BY AVG(be.sterne) DESC";


        }

        return "LOL";
    }
}
