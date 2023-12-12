import java.util.HashMap;
import java.util.Calendar;
import java.util.GregorianCalendar;
import java.text.SimpleDateFormat;

import java.util.Date;
import java.util.concurrent.TimeUnit;
import java.util.HashMap;
import java.text.SimpleDateFormat;

import java.util.HashMap;
import java.util.Calendar;
import java.util.GregorianCalendar;
import java.text.SimpleDateFormat;



HashMap<String, Integer> dailyTextCount = new HashMap<String, Integer>();
Date firstDate = null;
Date lastDate = null;
int allTexts = 0;

void setup() {
  size(1280, 720);
  loadData();
  background(255);
  drawGrid();
}

// void draw() {
  
// }

void loadData() {
  JSONObject json = loadJSONObject("yewe.json");
  JSONArray messages = json.getJSONArray("messages");

  for (int i = 0; i < messages.size(); i++) {
    JSONObject message = messages.getJSONObject(i);
    if (message.hasKey("date_unixtime") && message.hasKey("from")) {
      long unixTime = message.getLong("date_unixtime");
      Date date = new Date(unixTime * 1000L); 
      SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd"); 
      String dateString = sdf.format(date);
      if (dailyTextCount.containsKey(dateString)) {
        dailyTextCount.put(dateString, dailyTextCount.get(dateString) + 1);
      } else {
        dailyTextCount.put(dateString, 1);
      }

      if (firstDate == null || date.before(firstDate)) {
        firstDate = date;
      }

      if (lastDate == null || date.after(lastDate)) {
        lastDate = date;
      }
    }
  }

  for (String date : dailyTextCount.keySet()) {
    println("Date: " + date + ", Texts sent: " + dailyTextCount.get(date));
    allTexts += dailyTextCount.get(date);
  }
  println("total texts: "+ allTexts);
}

void drawGrid() {
  Calendar start = new GregorianCalendar();
  start.setTime(firstDate);
  Calendar end = new GregorianCalendar();
  end.setTime(lastDate);

  int startYear = start.get(Calendar.YEAR);
  int endYear = end.get(Calendar.YEAR);

  int cols = 53; 
  int rows = 7; 

  float cellWidth = 13; 
  float cellHeight = 13; 
  float spacing = 2; 
  float gridWidth = cols * (cellWidth + spacing);
  float gridHeight = rows * (cellHeight + spacing);

  float marginLeft = (width - gridWidth) / 2;

for (int year = startYear; year <= endYear; year++) {
  float gridY = (year - startYear) * (gridHeight + spacing + 20); 

 
  fill(0); 
  text(year, marginLeft - 50, gridY + gridHeight / 2);

  int yearTextCount = 0; 

  for (int i = 0; i < cols; i++) {
    for (int j = 0; j < rows; j++) {
      Calendar day = new GregorianCalendar(year, 0, i * rows + j + 1); 
      if (day.get(Calendar.YEAR) != year) continue; 
      SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
      String dateString = sdf.format(day.getTime());
      if (dailyTextCount.containsKey(dateString)) {
        int count = dailyTextCount.get(dateString);
        float brightness = map(count, 0, 10, 0, 255);
        fill(color(14,22,33, brightness));
        yearTextCount += dailyTextCount.get(dateString);
      } else {
        fill(120, 30); 
      }
      float x = marginLeft + i * (cellWidth + spacing); 
      float y = gridY + j * (cellHeight + spacing); 
      rect(x + 10, y + 10, cellWidth, cellHeight, 3);
    }
  }

  
  fill(0); 
  text(yearTextCount + " texts", marginLeft + gridWidth + 50, gridY + gridHeight / 2); 
}


}
