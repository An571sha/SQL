import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.concurrent.TimeUnit;

public class DateUtils {

    public static long compareDates(String date1, String date2){
        SimpleDateFormat format = new SimpleDateFormat("dd.MM.yyyy");
        try {

            Date formattedDate1 = format.parse(date1);
            Date formattedDate2 = format.parse(date2);

            if (formattedDate1.compareTo(formattedDate2) <= 0) {
                long diff = formattedDate2.getTime() - formattedDate1.getTime();
                return TimeUnit.DAYS.convert(diff, TimeUnit.MILLISECONDS);

            } else {

                System.out.println(" Please enter valid date intervals");

            }

        } catch (ParseException e) {
            e.printStackTrace();
        }

        return 0;
    }
}
