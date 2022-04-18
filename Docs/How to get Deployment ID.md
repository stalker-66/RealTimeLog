# How to get Deployment ID
For the backend, you will need a Google account because we will be creating a Spreadsheet via Google Drive.
## Backend setup
1. Sign in to your Google account.
2. Follow the link - [ExampleSpreadsheet.](https://docs.google.com/spreadsheets/d/14cy6SPEx61rtszgGKNYLHsnulwta8khzsiNDOIPnHsU/edit?usp=sharing)
3. You see an example of a Google Spreadsheet for a future log. Copy this example to your Google Drive and rename.
      <details>
      <summary>See more</summary>

      ![Make a copy](https://github.com/stalker-66/RealTimeLog/blob/f1f8cbed86b519e3d7dd067033dc00cdc20dbdeb/Docs/res/1.png?raw=true)
      ![Make a copy](https://github.com/stalker-66/RealTimeLog/blob/f1f8cbed86b519e3d7dd067033dc00cdc20dbdeb/Docs/res/2.png?raw=true)

      </details>
      
     **Messages from the device will be sent to this Spreadsheet.**
4. Copy the Spreadsheet ID from url.
      <details>
      <summary>See more</summary>

      ![Make a copy](https://github.com/stalker-66/RealTimeLog/blob/f1f8cbed86b519e3d7dd067033dc00cdc20dbdeb/Docs/res/3.png?raw=true)

      </details>
 5. Go to the tab "Extensions" and select "Apps Script".
      <details>
      <summary>See more</summary>

      ![Make a copy](https://github.com/stalker-66/RealTimeLog/blob/f1f8cbed86b519e3d7dd067033dc00cdc20dbdeb/Docs/res/4.png?raw=true)

      </details>
 6. You need to replace "id_spreadsheet" with your Spreadsheet ID.
      <details>
      <summary>See more</summary>

      ![Make a copy](https://github.com/stalker-66/RealTimeLog/blob/f1f8cbed86b519e3d7dd067033dc00cdc20dbdeb/Docs/res/5.png?raw=true)
      ![Make a copy](https://github.com/stalker-66/RealTimeLog/blob/f1f8cbed86b519e3d7dd067033dc00cdc20dbdeb/Docs/res/6.png?raw=true)

      </details>
 7. Save the project. Now we need to publish it.
      <details>
      <summary>See more</summary>

      ![Make a copy](https://github.com/stalker-66/RealTimeLog/blob/f1f8cbed86b519e3d7dd067033dc00cdc20dbdeb/Docs/res/7.png?raw=true)
      ![Make a copy](https://github.com/stalker-66/RealTimeLog/blob/f1f8cbed86b519e3d7dd067033dc00cdc20dbdeb/Docs/res/8.png?raw=true)

      </details>
8. Select Settings > Web app. You must specify the parameters:
      * **Execute as:** Me
      * **Who has access:** Anyone

      Click "Deploy".
      
      <details>
      <summary>See more</summary>

      ![Make a copy](https://github.com/stalker-66/RealTimeLog/blob/f1f8cbed86b519e3d7dd067033dc00cdc20dbdeb/Docs/res/9.png?raw=true)
      ![Make a copy](https://github.com/stalker-66/RealTimeLog/blob/f1f8cbed86b519e3d7dd067033dc00cdc20dbdeb/Docs/res/10.png?raw=true)

      </details>
9. Click "Authorize access" and select Google account.

      > If you see a warning: "Google hasn't verified this app", you must click "Show Advanced" and "Go to RemoteLogger (unsafe)"
      
      Click "Allow".
      <details>
      <summary>See more</summary>

      ![Make a copy](https://github.com/stalker-66/RealTimeLog/blob/f1f8cbed86b519e3d7dd067033dc00cdc20dbdeb/Docs/res/11.png?raw=true)
      ![Make a copy](https://github.com/stalker-66/RealTimeLog/blob/f1f8cbed86b519e3d7dd067033dc00cdc20dbdeb/Docs/res/12.png?raw=true)
      ![Make a copy](https://github.com/stalker-66/RealTimeLog/blob/f1f8cbed86b519e3d7dd067033dc00cdc20dbdeb/Docs/res/13.png?raw=true)
      ![Make a copy](https://github.com/stalker-66/RealTimeLog/blob/f1f8cbed86b519e3d7dd067033dc00cdc20dbdeb/Docs/res/14.png?raw=true)

      </details>
10. Get your Deployment ID and click "Done".
      <details>
      <summary>See more</summary>

      ![Make a copy](https://github.com/stalker-66/RealTimeLog/blob/f1f8cbed86b519e3d7dd067033dc00cdc20dbdeb/Docs/res/15.png?raw=true)

      </details>
