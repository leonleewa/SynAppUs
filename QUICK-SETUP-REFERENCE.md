# Quick Setup Reference - Google Sheets Integration

## 🚀 Quick Start (5 Minutes)

### 1️⃣ Create Google Sheet
- Go to [sheets.google.com](https://sheets.google.com)
- Create new spreadsheet: "SynAppUs Contact Form Submissions"
- Add headers in Row 1: `Timestamp | Name | Email | Phone | Plan | Subject | Message`

### 2️⃣ Set Up Apps Script
- In your sheet: **Extensions > Apps Script**
- Delete existing code
- Paste the Google Apps Script code (from GOOGLE-SHEETS-SETUP.md)
- Save with name: "SynAppUs Contact Form Handler"

### 3️⃣ Deploy as Web App
- Click **Deploy > New deployment**
- Select type: **Web app**
- Set:
  - Execute as: **Me**
  - Who has access: **Anyone**
- Click **Deploy** and authorize
- **Copy the Web App URL** (save it!)

### 4️⃣ Update Your Website
- Open `site/contacts.html`
- Find line with: `data-google-script-url="YOUR_GOOGLE_SCRIPT_URL_HERE"`
- Replace with your Web App URL
- Save and upload to your server

### 5️⃣ Test It!
- Go to synapp.us/contacts.html
- Fill out and submit the form
- Check your Google Sheet - new row should appear!

---

## 🔗 Important URLs

**Google Sheets:** https://sheets.google.com  
**Apps Script Docs:** https://developers.google.com/apps-script  
**Your Web App URL:** (paste here after deployment) ______________________

---

## 📋 Field Mapping

| Form Field | Google Sheet Column | Required |
|------------|-------------------|----------|
| Name | Name | ✅ Yes |
| Email | Email | ✅ Yes |
| Phone | Phone | ✅ Yes |
| Plan | Plan | ✅ Yes |
| Subject | Subject | ✅ Yes |
| Message | Message | ❌ No |
| - | Timestamp | ✅ Auto |

---

## ⚙️ Configuration Checklist

- [ ] Google Sheet created with correct headers
- [ ] Apps Script code deployed as Web App
- [ ] Web App URL copied
- [ ] contacts.html updated with Web App URL
- [ ] Updated file uploaded to server
- [ ] Test submission successful
- [ ] Data visible in Google Sheets

---

## 🛠️ Troubleshooting

**Form shows error?**
→ Check that Web App URL is correctly pasted in contacts.html

**No data in sheet?**
→ Verify "Who has access" is set to "Anyone" in deployment settings

**CORS errors?**
→ Normal with no-cors mode - if data appears in sheet, it's working!

---

## 📧 Optional: Email Notifications

To get notified of new submissions:

1. Open Apps Script editor
2. Find the commented `MailApp.sendEmail` section
3. Uncomment it (remove `/*` and `*/`)
4. Replace `'your-email@example.com'` with your email
5. Save and redeploy

---

## 🔒 Security Features

✅ Input sanitization  
✅ Field validation  
✅ HTTPS encryption  
✅ No database needed  
✅ CORS configured  
✅ Free & serverless  

---

## 📞 Form Fields Captured

1. **Name** - User's full name (min 2 characters)
2. **Email** - Valid email address
3. **Phone** - Phone number with format validation
4. **Plan** - Selected pricing plan:
   - Basic ($100/month)
   - Business ($450/month)
   - Business Pro ($800/month)
   - Enterprise (Custom)
   - Not sure yet
5. **Subject** - Inquiry subject (auto-populated based on plan)
6. **Message** - Optional additional details

---

## 📊 What Happens When Form is Submitted?

1. User fills out form on synapp.us/contacts.html
2. JavaScript validates all required fields
3. Data is sent via POST request to Google Apps Script
4. Script sanitizes and validates data
5. New row added to Google Sheet with timestamp
6. Optional: Email notification sent to admin
7. User sees success message on website
8. Form resets for next submission

---

## 🎯 Success Indicators

✅ Success message appears after form submission  
✅ New row visible in Google Sheet with correct data  
✅ Timestamp shows current date/time  
✅ All fields populated correctly  

---

## 💡 Pro Tips

- **Freeze header row** in Google Sheets for easier scrolling
- **Format timestamp column** as Date/Time
- **Add conditional formatting** to Plan column for visual distinction
- **Enable email notifications** to respond quickly to inquiries
- **Export data regularly** as backup (File > Download > CSV)
- **Create a dashboard sheet** for analytics and reporting

---

## 🔄 To Update the Script Later

1. Open Apps Script editor
2. Make your changes
3. Save the file
4. Go to **Deploy > Manage deployments**
5. Click pencil icon ✏️ next to your deployment
6. Click **Deploy**
7. **Web App URL remains the same** - no need to update website!

---

**Need detailed instructions? See GOOGLE-SHEETS-SETUP.md**
