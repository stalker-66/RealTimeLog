function clearLog()
{
  // select sheet
  let sheet = SpreadsheetApp.getActiveSpreadsheet().getSheetByName('Log');
  let rows = sheet.getDataRange();
  let numRows = rows.getNumRows();

  for (let i = numRows; i >= 3; i--) {
    sheet.deleteRow(i);
  }
  sheet.getRange("A2"+":E2").setBackground("#ffffff").clearContent();
}

function doGet(e)
{
  let sheet = SpreadsheetApp.getActiveSpreadsheet().getSheetByName('Log');
  let n = sheet.getLastRow() + 1;

  // clear
  if ( e != null && e.parameter != null && e.parameter["isClear"] != null && e.parameter["isClear"] == 1 ) {
    clearLog();

    // response
    let resp = {};
    resp.success = 1;

    return ContentService.createTextOutput(JSON.stringify(resp));
  }

  // types
  let typeIdList = ["Info","Warning","Error","New Session"];
  let colorIdList = ["#ffffff","#ffe599","#ea9999","#b6d7a8"];

  // user id
  let userId = "Default"
  if ( e != null && e.parameter != null && e.parameter["userId"] != null ) {
    userId = e.parameter["userId"];
    userId = Utilities.base64Decode( userId, Utilities.Charset.UTF_8 );
    userId = Utilities.newBlob( userId ).getDataAsString();
  }

  // platform
  let platform = "Default"
  if ( e != null && e.parameter != null && e.parameter["platform"] != null ) {
    platform = e.parameter["platform"];
    platform = Utilities.base64Decode( platform, Utilities.Charset.UTF_8 );
    platform = Utilities.newBlob( platform ).getDataAsString();
  }

  // date
  let date = "--/--/-- --:--:--";

  // message
  let typeId = "0";
  let isSearch = 0;
  for (let j = 0; j < 10; j++) {
    if ( e != null && e.parameter != null && e.parameter["p" + j] != null ) {
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
    // response
    let resp = {};
    resp.success = 1;
    resp.desc = 'Failed. There are no messages to log.';

    return ContentService.createTextOutput(JSON.stringify(resp));
  }

  // response
  let resp = {};
  resp.success = 1;

  return ContentService.createTextOutput(JSON.stringify(resp));
}