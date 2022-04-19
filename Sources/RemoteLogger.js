function doGet(e)
{
  var sheet = SpreadsheetApp.openById("id_spreadsheet");
  var n = sheet.getLastRow() + 1;

  // clear
  if (e.parameter["isClear"] != null && e.parameter["isClear"] == 1) {
    sheet.getRange("A2"+":E"+n).setBackground("#ffffff").clearContent();
    return ContentService.createTextOutput("Clear Log: Success");
  }

  // types
  var typeIdList = ["Info","Warning","Error","New Session"];
  var colorIdList = ["#ffffff","#ffe599","#ea9999","#b6d7a8"];

  // user id
  var userId = "Default"
  if (e.parameter["userId"] != null) {
    userId = e.parameter["userId"];
    userId = Utilities.base64Decode( userId, Utilities.Charset.UTF_8 );
    userId = Utilities.newBlob( userId ).getDataAsString();
  }

  // platform
  var platform = "Default"
  if (e.parameter["platform"] != null) {
    platform = e.parameter["platform"];
    platform = Utilities.base64Decode( platform, Utilities.Charset.UTF_8 );
    platform = Utilities.newBlob( platform ).getDataAsString();
  }

  // date
  var date = "--/--/-- --:--:--";

  // message
  var typeId = "0";
  var isSearch = 0;
  for (var j = 0; j < 10; j++) {
    if (e.parameter["p" + j] != null) {
      e.parameter["p" + j] = Utilities.base64Decode( e.parameter["p" + j], Utilities.Charset.UTF_8 );
      e.parameter["p" + j] = Utilities.newBlob( e.parameter["p" + j] ).getDataAsString()
      sheet.getRange("C"+n).setValue(e.parameter["p" + j]);

      if (e.parameter["t" + j] != null && e.parameter["t" + j] >=0 && e.parameter["t" + j] <= typeIdList.length-1) {
        typeId = parseInt(e.parameter["t" + j]);
      }

      sheet.getRange("D"+n).setValue( typeIdList[typeId] );
      sheet.getRange("A"+n+":E"+n).setBackground( colorIdList[typeId] );

      sheet.getRange("B"+n).setValue(userId);

      if (e.parameter["d" + j] != null) {
        e.parameter["d" + j] = Utilities.base64Decode( e.parameter["d" + j], Utilities.Charset.UTF_8 );
        sheet.getRange("A"+n).setValue( Utilities.newBlob( e.parameter["d" + j] ).getDataAsString() );
      } else {
        sheet.getRange("A"+n).setValue(date);
      }

      sheet.getRange("E"+n).setValue(platform);

      isSearch = 1;
      n++;
    }
  }

  if (isSearch == 0) {
    return ContentService.createTextOutput("Send to Log: Failed. There are no messages to log.");
  }

  return ContentService.createTextOutput("Send to Log: Success");
}