function doGet(e)
{
  var sheet = SpreadsheetApp.openById("id_spreadsheet");
  var n = sheet.getLastRow() + 1;

  // clear
  if (e.parameter["isClear"] != null && e.parameter["isClear"] == 1) {
    sheet.getRange("A2"+":D"+n).setBackground("#ffffff").clearContent();
    return ContentService.createTextOutput("Clear Log: Success");
  }

  // types
  var typeIdList = ["Info","Warning","Error","New Session"];
  var colorIdList = ["#ffffff","#ffe599","#ea9999","#b6d7a8"];

  // user id
  var userId = "Default"
  if (e.parameter["userId"] != null) {
    userId = e.parameter["userId"];
  }

  // date
  var today = new Date();
  var date = today.toLocaleString();

  // message
  var typeId = 0;
  var isSearch = 0;
  for (var j = 0; j < 10; j++) {
    if (e.parameter["p" + j] != null) {
      sheet.getRange("C"+n).setValue(e.parameter["p" + j]);

      if (e.parameter["t" + j] != null && e.parameter["t" + j] >=0 && e.parameter["t" + j] <= typeIdList.length-1) {
        typeId = e.parameter["t" + j];
      }

      sheet.getRange("D"+n).setValue(typeIdList[typeId]);
      sheet.getRange("A"+n+":D"+n).setBackground(colorIdList[typeId]);

      sheet.getRange("B"+n).setValue(userId);

      if (e.parameter["d" + j] != null) {
        sheet.getRange("A"+n).setValue(e.parameter["d" + j]);
      } else {
        sheet.getRange("A"+n).setValue(date);
      }

      isSearch = 1;
      n++;
    }
  }

  if (isSearch == 0) {
    return ContentService.createTextOutput("Send to Log: Failed. There are no messages to log.");
  }

  return ContentService.createTextOutput("Send to Log: Success");
}