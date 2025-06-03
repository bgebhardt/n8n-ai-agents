Very rough notes... need to clean up.

## N8N and NVMe

used NVM to run multiple versions of node

- [ ] Process nvm caveats #coding 📅 2025-06-09
[nvm-sh/nvm: Node Version Manager - POSIX-compliant bash script to manage multiple active node.js versions](https://github.com/nvm-sh/nvm?tab=readme-ov-file#installing-and-updating)
==> Caveats
Please note that upstream has asked us to make explicit managing
nvm via Homebrew is unsupported by them and you should check any
problems against the standard nvm install method prior to reporting.

You should create NVM's working directory if it doesn't exist:
  mkdir ~/.nvm

Add the following to your shell profile e.g. ~/.profile or ~/.zshrc:
  export NVM_DIR="$HOME/.nvm"
  [ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh"  # This loads nvm
  [ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"  # This loads nvm bash_completion

You can set $NVM_DIR to any location, but leaving it unchanged from
/opt/homebrew/Cellar/nvm/0.40.3 will destroy any nvm-installed Node installations
upon upgrade/reinstall.

### n8n demo
chat to look up your calendar info... cool!

- [ ] try n8N tutorial 📅 2025-06-09
[A longer introduction | n8n Docs](https://docs.n8n.io/try-it-out/tutorial-first-workflow/)
Stopped at setting up calendar in the demo workflow
[▶️ Demo: My first AI Agent in n8n - n8n\[DEV\]](http://localhost:5678/workflow/IotBZx0hnuXDncSR/eb17ac)

Try importing this one
[Automated Stock Analysis Reports with Technical & News Sentiment using GPT-4o | n8n workflow template](https://n8n.io/workflows/3790-automated-stock-analysis-reports-with-technical-and-news-sentiment-using-gpt-4o/)

Look at more examples here: [Discover 118 Automation Workflows from the n8n's Community](https://n8n.io/workflows/categories/finance/?q=stock)

Docs, github:
[Explore n8n Docs: Your Resource for Workflow Automation and Integrations | n8n Docs](https://docs.n8n.io/)
[n8n-io/n8n: Fair-code workflow automation platform with native AI capabilities. Combine visual building with custom code, self-host or cloud, 400+ integrations.](https://github.com/n8n-io/n8n)

A few links

- docs [Explore n8n Docs: Your Resource for Workflow Automation and Integrations | n8n Docs]([https://docs.n8n.io/)](https://docs.n8n.io/\) "https://docs.n8n.io/)")
- github project [n8n-io/n8n: Fair-code workflow automation platform with native AI capabilities. Combine visual building with custom code, self-host or cloud, 400+ integrations.]([https://github.com/n8n-io/n8n)](https://github.com/n8n-io/n8n\) "https://github.com/n8n-io/n8n)")
- repository of workflows you can just import in and try: ⁠[Discover 118 Automation Workflows from the n8n's Community]([https://n8n.io/workflows/categories/finance/?q=stock)](https://n8n.io/workflows/categories/finance/?q=stock\) "https://n8n.io/workflows/categories/finance/?q=stock)")

### add tester emails to fix issues with signing in

How to Add Developer-Approved Testers to a Google Cloud App

To allow specific users to access your Google Cloud app while it is in testing and has not completed Google verification, you need to add them as testers or grant them access through your Google Cloud project. Here’s how you can do this:

**1. Add Testers via Google Cloud IAM**

- Open the IAM page in the Google Cloud Console.
- Select your project.
- Click **Add**.
- Enter the email address of the tester you want to approve.
- Assign appropriate roles (such as Viewer, Editor, or a custom role needed for app testing).
- Click **Save**.

This gives the tester access to the project and allows them to use the app as a developer-approved tester[1][4].

**2. For OAuth Apps in Testing**

If your app uses OAuth and is still unverified, only users added as testers in the OAuth consent screen settings can use the app without seeing the "unverified app" warning or hitting the 100-user cap. To add testers:

- Go to the Google Cloud Console.
- Navigate to **APIs & Services** > **OAuth consent screen**.
- In the **Test users** section, click **Add users** and enter the email addresses of the testers.
- Save your changes.

Only these users will be able to authorize with your app while it is unverified[3].

**3. For Firebase App Distribution (if applicable)**

If you are distributing a mobile app for testing using Firebase:

- Go to the Firebase Console.
- Navigate to **App Distribution** > **Testers & Groups**.
- Click **Add tester**.
- Enter the tester’s email address and click **Add tester**.

This process is specific to Firebase App Distribution and is used for mobile app testing[2].

---

**Summary Table**

| Platform/Method         | Where to Add Testers                | Steps                                                                                 |
|------------------------|-------------------------------------|--------------------------------------------------------------------------------------|
| Google Cloud IAM       | IAM page in Cloud Console           | Add user’s email, assign role, save                                                  |
| OAuth Consent Screen   | APIs & Services > OAuth consent     | Add emails under “Test users”                                                        |
| Firebase App Distribution | App Distribution > Testers & Groups | Add tester’s email, click “Add tester”                                               |

---

**Note:**  
- Only users you explicitly add as testers will be able to access the app until it is verified and publicly available[3][4].
- If you need to test new OAuth scopes, use a separate development project and add testers there as well[5].

Sources
[1] Setting up access control | Google App Engine standard ... https://cloud.google.com/appengine/docs/standard/access-control
[2] Add, remove, and search for testers in App Distribution - Firebase https://firebase.google.com/docs/app-distribution/add-remove-search-testers
[3] Unverified apps - Google Cloud Platform Console Help https://support.google.com/cloud/answer/7454865
[4] Test a Cloud-to-Cloud integration - Google Home Developers https://developers.home.google.com/cloud-to-cloud/test
[5] Changes to approved app - Google Cloud Platform Console Help https://support.google.com/cloud/answer/13464018
[6] Configure the OAuth consent screen and choose scopes https://developers.google.com/workspace/guides/configure-oauth-consent
[7] How to give access to a different google user and test my Dialogflow ... https://stackoverflow.com/questions/60793012/how-to-give-access-to-a-different-google-user-and-test-my-dialogflow-app
[8] Get set up as a tester with App Distribution - Firebase - Google https://firebase.google.com/docs/app-distribution/get-set-up-as-a-tester
[9] Test and deploy your application | Google App Engine standard ... https://cloud.google.com/appengine/docs/standard/testing-and-deploying-your-app
[10] Setup Google OAuth sign in 6 minutes - YouTube https://www.youtube.com/watch?v=tgO_ADSvY1I
