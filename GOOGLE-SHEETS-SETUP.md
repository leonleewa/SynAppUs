# Google Sheets Contact Form Integration Setup Guide

## Overview
This guide will walk you through connecting your SynAppUs contact form to Google Sheets using Google Apps Script. No backend server required - it's completely serverless!

---

## Part 1: Create Your Google Sheet

### Step 1: Create a New Spreadsheet
1. Go to [Google Sheets](https://sheets.google.com)
2. Click **+ Blank** to create a new spreadsheet
3. Name it: **"SynAppUs Contact Form Submissions"**

### Step 2: Set Up Column Headers
In the first row (Row 1), add these exact column headers:

| A | B | C | D | E | F | G |
|---|---|---|---|---|---|---|
| Timestamp | Name | Email | Phone | Plan | Subject | Message |

**Tip:** You can format the header row:
- Make it **bold**
- Add a background color (e.g., light blue)
- Freeze the first row: View > Freeze > 1 row

---

## Part 2: Set Up Google Apps Script

### Step 3: Open Apps Script Editor
1. In your Google Sheet, go to **Extensions** > **Apps Script**
2. This opens the Script Editor in a new tab
3. You'll see a default `Code.gs` file with some sample code

### Step 4: Paste the Backend Code
1. **Delete all existing code** in the editor
2. Copy and paste the following code:

```javascript
/**
 * SynAppUs Contact Form to Google Sheets Integration
 * This script receives POST requests from the contact form and writes data to the sheet
 */

// Main function to handle POST requests
function doPost(e) {
  try {
    // Parse the incoming data
    const data = JSON.parse(e.postData.contents);
    
    // Get the active spreadsheet
    const sheet = SpreadsheetApp.getActiveSpreadsheet().getActiveSheet();
    
    // Validate required fields
    if (!data.name || !data.email || !data.phone || !data.plan || !data.subject) {
      return ContentService
        .createTextOutput(JSON.stringify({
          success: false,
          message: 'Missing required fields'
        }))
        .setMimeType(ContentService.MimeType.JSON);
    }
    
    // Sanitize inputs to prevent injection
    const sanitize = (str) => {
      if (typeof str !== 'string') return '';
      return str.replace(/[<>]/g, '').trim();
    };
    
    // Prepare the row data
    const timestamp = new Date();
    const rowData = [
      timestamp,
      sanitize(data.name),
      sanitize(data.email),
      sanitize(data.phone),
      sanitize(data.plan),
      sanitize(data.subject),
      sanitize(data.message || '')
    ];
    
    // Append the data to the sheet
    sheet.appendRow(rowData);
    
    // Optional: Send email notification to admin
    // Uncomment and configure if you want email notifications
    /*
    MailApp.sendEmail({
      to: 'your-email@example.com',
      subject: 'New Contact Form Submission - ' + data.subject,
      body: `
        New contact form submission received:
        
        Name: ${data.name}
        Email: ${data.email}
        Phone: ${data.phone}
        Plan: ${data.plan}
        Subject: ${data.subject}
        Message: ${data.message || 'No message'}
        
        Timestamp: ${timestamp}
      `
    });
    */
    
    // Return success response
    return ContentService
      .createTextOutput(JSON.stringify({
        success: true,
        message: 'Form submitted successfully'
      }))
      .setMimeType(ContentService.MimeType.JSON);
      
  } catch (error) {
    // Log error for debugging
    Logger.log('Error: ' + error.toString());
    
    // Return error response
    return ContentService
      .createTextOutput(JSON.stringify({
        success: false,
        message: 'Server error: ' + error.toString()
      }))
      .setMimeType(ContentService.MimeType.JSON);
  }
}

// Test function for GET requests
function doGet(e) {
  return ContentService
    .createTextOutput(JSON.stringify({
      status: 'active',
      message: 'Contact form endpoint is working'
    }))
    .setMimeType(ContentService.MimeType.JSON);
}
```

3. Click the **Save** icon (💾) or press `Ctrl+S` / `Cmd+S`
4. Give your project a name: **"SynAppUs Contact Form Handler"**

---

## Part 3: Deploy as Web App

### Step 5: Deploy the Script
1. In the Apps Script editor, click **Deploy** > **New deployment**
2. Click the gear icon ⚙️ next to "Select type"
3. Choose **Web app**
4. Configure the deployment:
   - **Description**: `Contact Form to Sheets`
   - **Execute as**: **Me** (your@email.com)
   - **Who has access**: **Anyone**
5. Click **Deploy**

### Step 6: Authorize the Script
1. You'll see an "Authorization required" dialog
2. Click **Authorize access**
3. Select your Google account
4. Click **Advanced** (if you see a warning)
5. Click **Go to SynAppUs Contact Form Handler (unsafe)**
6. Click **Allow**

### Step 7: Copy the Web App URL
1. After authorization, you'll see a success message with a **Web app URL**
2. **IMPORTANT:** Copy this URL - it looks like:
   ```
   https://script.google.com/macros/s/AKfycbx.../exec
   ```
3. Save it somewhere safe - you'll need it in the next step!

---

## Part 4: Connect Your Website Form

### Step 8: Update the contacts.html File
1. Open `site/contacts.html` in your code editor
2. Find this line (around line 342):
   ```html
   <form id="contact-form" class="space-y-6" novalidate data-google-script-url="YOUR_GOOGLE_SCRIPT_URL_HERE">
   ```
3. Replace `YOUR_GOOGLE_SCRIPT_URL_HERE` with your actual Web App URL from Step 7:
   ```html
   <form id="contact-form" class="space-y-6" novalidate data-google-script-url="https://script.google.com/macros/s/AKfycbx.../exec">
   ```
4. Save the file

### Step 9: Deploy to Your Website
1. Upload the updated `contacts.html` file to your web server
2. Clear your browser cache or do a hard refresh (`Ctrl+F5`)

---

## Part 5: Test the Integration

### Step 10: Submit a Test Form
1. Go to your live website: `https://synapp.us/contacts.html`
2. Fill out the contact form with test data
3. Click **Submit**
4. You should see the success message

### Step 11: Verify in Google Sheets
1. Go back to your Google Sheet
2. Refresh the page
3. You should see a new row with the test submission data!

**Example of what you should see:**

| Timestamp | Name | Email | Phone | Plan | Subject | Message |
|-----------|------|-------|-------|------|---------|---------|
| 12/10/2025 10:30:45 | John Doe | john@example.com | +1 555-123-4567 | business-pro | Business Pro Plan Inquiry | Looking to integrate CRM... |

---

## Security & CORS Configuration

### How CORS is Handled
- Google Apps Script automatically handles CORS for web apps deployed with "Anyone" access
- The script uses `no-cors` mode in the fetch request, which is required for cross-origin requests to Google Apps Script
- Data sanitization is built into the script to prevent injection attacks

### Security Features
✅ Input sanitization (removes potentially harmful characters)  
✅ Required field validation  
✅ Email format validation  
✅ Phone number format validation  
✅ HTTPS encryption (Google Apps Script uses HTTPS by default)  
✅ No sensitive data stored in frontend code  

---

## Optional Enhancements

### Enable Email Notifications
To receive an email every time someone submits the form:

1. Open your Apps Script editor
2. Find the commented section around line 43:
   ```javascript
   // Optional: Send email notification to admin
   // Uncomment and configure if you want email notifications
   /*
   MailApp.sendEmail({
     to: 'your-email@example.com',
   ```
3. Remove the `/*` and `*/` comment markers
4. Replace `'your-email@example.com'` with your actual email
5. Save and deploy a new version:
   - Click **Deploy** > **Manage deployments**
   - Click the pencil icon ✏️ next to your deployment
   - Click **Deploy**

### Format Your Google Sheet
Make it easier to read:
- **Timestamp column**: Format > Number > Date time
- **Email column**: Add data validation or conditional formatting
- **Plan column**: Add conditional formatting with colors for each plan type
- **Freeze header row**: View > Freeze > 1 row

### Add Automatic Responses (Advanced)
You can modify the script to send auto-reply emails to users who submit the form using `MailApp.sendEmail()`.

---

## Troubleshooting

### Problem: Form shows "not configured" error
**Solution:** Make sure you replaced `YOUR_GOOGLE_SCRIPT_URL_HERE` with your actual Web App URL in `contacts.html`

### Problem: Nothing appears in Google Sheets
**Solution:** 
1. Check that you deployed the script as a Web App (not as an API executable)
2. Make sure "Who has access" is set to **Anyone**
3. Try redeploying: Deploy > Manage deployments > Edit > Deploy

### Problem: Authorization errors
**Solution:**
1. Make sure "Execute as" is set to **Me** (your account)
2. Re-authorize the script if needed
3. Check that your Google account has permission to edit the spreadsheet

### Problem: CORS errors in browser console
**Solution:**
- This is expected with `no-cors` mode
- As long as data appears in your sheet, it's working correctly
- The frontend assumes success if no error is thrown

---

## Data Management

### Viewing Submissions
- All submissions appear in your Google Sheet in real-time
- Each row = one submission
- Newest submissions appear at the bottom

### Exporting Data
- File > Download > Microsoft Excel (.xlsx)
- File > Download > CSV

### Managing Data
- You can sort, filter, and analyze submissions directly in Google Sheets
- Consider creating a second sheet for analytics/summaries
- Use Google Sheets formulas to count submissions by plan type, etc.

---

## Maintenance

### Updating the Script
1. Go to your Apps Script editor
2. Make changes to the code
3. Save the file
4. Deploy > Manage deployments > Edit (pencil icon) > Deploy
5. **Note:** The Web App URL stays the same, so you don't need to update your website

### Monitoring
- Check your Google Sheet regularly for new submissions
- Set up email notifications (see Optional Enhancements above)
- Consider creating a Google Sheets dashboard with charts/stats

---

## Support

### Need Help?
- Check the [Google Apps Script documentation](https://developers.google.com/apps-script)
- Review browser console for errors (F12 > Console tab)
- Test the Web App URL directly in your browser to see if it responds

### Testing Checklist
- [ ] Google Sheet created with correct headers
- [ ] Apps Script code pasted and saved
- [ ] Script deployed as Web App with "Anyone" access
- [ ] Web App URL copied
- [ ] contacts.html updated with Web App URL
- [ ] File uploaded to web server
- [ ] Test submission completed
- [ ] Data appears in Google Sheet

---

## Summary

You now have a fully functional, serverless contact form integration that:
- ✅ Captures all form fields (name, email, phone, plan, subject, message)
- ✅ Stores submissions in Google Sheets instantly
- ✅ Works without a backend server
- ✅ Is secure and sanitizes inputs
- ✅ Handles CORS correctly
- ✅ Shows success/error messages to users
- ✅ Is completely free to use

**No ongoing costs, no server maintenance required!**
