# Initial labs setup 

## Creating a Microsoft Azure Pass Subscription
Creating an Azure Pass subscription is a two step process.
Please create and use a New Microsoft Live ID email account for your redemption. Do not redeem against your existing work/school email.

#### Step 1: Redeeming a Microsoft Azure Pass Promo Code:
Open a browser and navigate to: https://www.microsoftazurepass.com/
It is recommended you close all browsers and open a new In-Private Browser session. Other log-ins can persist and cause errors during the activation step.
Click the start button to get started.
Enter your account login information and select “Sign In”.
Click “Confirm” if the correct email address is listed.
Enter your promo code Qxxxxxxxx in the Promo code box and click “Claim Promo Code”.
It may take up to 5 minutes to process the redemption.

#### Step 2: Activate your subscription:
When the redemption process is completed, it will redirect to the sign up page.
Enter your account information and click “Next”.
Click the agreement check box and click the Sign up button.
Enter your account information and click “Submit”.
It may take a few minutes to process the request.
You can check the balance of your Azure Pass Credits on https://www.microsoftazuresponsorships.com/balance


## Instructions to create an Azure DevOps Organization (you only have to do this once)

Note: Start at step 3, if you do already have a personal Microsoft Account setup and an active Azure Subscription linked to that account.
Use a private browser session to get a new personal Microsoft Account (MSA) at https://account.microsoft.com.

Using the same browser session, sign up for a free Azure subscription at https://azure.microsoft.com/free.

Open a browser and navigate to Azure portal at https://portal.azure.com, then search at the top of the Azure portal screen for Azure DevOps. In the resulting page, click Azure DevOps organizations.

Next, click on the link labelled My Azure DevOps Organizations or navigate directly to https://aex.dev.azure.com.

On the We need a few more details page, select Continue.

In the drop-down box on the left, choose Default Directory, instead of Microsoft Account.

If prompted ("We need a few more details"), provide your name, e-mail address, and location and click Continue.

Back at https://aex.dev.azure.com with Default Directory selected click the blue button Create new organization.

Accept the Terms of Service by clicking Continue.

If prompted ("Almost done"), leave the name for the Azure DevOps organization at default (it needs to be a globally unique name) and pick a hosting location close to you from the list.

Once the newly created organization opens in Azure DevOps, select Organization settings in the bottom left corner.

At the Organization settings screen select Billing (opening this screen takes a few seconds).

Select Setup billing and on the right-hand side of the screen, select your Azure Subscription and then select Save to link the subscription with the organization.

Once the screen shows the linked Azure Subscription ID at the top, change the number of Paid parallel jobs for MS Hosted CI/CD from 0 to 1. Then select SAVE button at the bottom.

You may wait at least 3 hours before using the CI/CD capabilities so that the new settings are reflected in the backend. Otherwise, you will still see the message "No hosted parallelism has been purchased or granted".

## Instructions to create and configure the Azure DevOps project (you only have to do this once)

Note: make sure you completed the steps to create your Azure DevOps Organization before continuing with these steps.
To follow all lab instructions, you'll need set up a new Azure DevOps project, create a repository that's based on the eShopOnWeb https://github.com/MicrosoftLearning/eShopOnWeb application, and create a service connection to your Azure subscription.

### Create the team project

First, you'll create an eShopOnWeb Azure DevOps project to be used by several labs.

Open your browser and navigate to your Azure DevOps organization.

Select the New Project option and use the following settings:

name: eShopOnWeb
visibility: Private
Advanced: Version Control: Git
Advanced: Work Item Process: Scrum
Select Create.

Create Project

### Import eShopOnWeb git repository

Now, you'll import the eShopOnWeb into your git repository.

Open your browser and navigate to your Azure DevOps organization.

Open the previously created eShopOnWeb project.

Select the Repos > Files, Import a Repository and then select Import.

On the Import a Git Repository window, paste the following URL https://github.com/MicrosoftLearning/eShopOnWeb and select Import:

Import Repository

The repository is organized the following way:

.ado folder contains Azure DevOps YAML pipelines.
.devcontainer folder container setup to develop using containers (either locally in VS Code or GitHub Codespaces).
.azure folder contains Bicep & ARM infrastructure as code templates.
.github folder container YAML GitHub workflow definitions.
src folder contains the .NET 6 website used on the lab scenarios.
Leave the web browser window open.

### Create a service principal and service connection to access Azure resources

Next, you will create a service principal by using the Azure CLI, and a service connection in Azure DevOps which will allow you to deploy and access resources in your Azure subscription.

Start a web browser, navigate to the Azure Portal at https://portal.azure.com, and sign in with the user account that has the Owner role in the Azure subscription you will be using in the labs of this course and has the role of the Global Administrator in the Microsoft Entra tenant associated with this subscription.

On the Azure portal, select the Cloud Shell icon, located directly to the right of the search textbox at the top of the page.

If prompted to select either Bash or PowerShell, select Bash.

If this is the first time you are starting Cloud Shell and you are presented with the You have no storage mounted message, select the subscription you are using in this lab, and select Create storage.
From the Bash prompt, in the Cloud Shell pane, run the following commands to retrieve the values of the Azure subscription ID and subscription name attributes:

```bash
   subscriptionName=$(az account show --query name --output tsv)
   subscriptionId=$(az account show --query id --output tsv)
   echo $subscriptionName
   echo $subscriptionId
```
[!NOTE] Copy both values to a text file. You will need them in the labs of this course.
From the Bash prompt in the Cloud Shell pane, run the following command to create a Service Principal:
```bash
   az ad sp create-for-rbac --name sp-eshoponweb-azdo --role contributor --scopes /subscriptions/$subscriptionId
```
[!NOTE] The command will generate a JSON output. Copy the output to text file. You will need it shortly.
[!NOTE] Record the value of, security principal name, its Id, and tenant Id included in the JSON output. You will need them in the labs of this course.
Switch back to the web browser window displaying the Azure DevOps portal with the eShopOnWeb project open and select Project settings in the bottom left corner of the portal.

Select the Service connections under Pipelines, and then select Create service connection button.

Screenshot of the new service connection creation button.

On the New service connection blade, select Azure Resource Manager and Next (may need to scroll down).

Then choose Service Principal (manual) and select Next.

Fill in the empty fields using the information gathered during previous steps:

Subscription Id and Name.
Service Principal Id (or clientId/AppId), Service Principal Key (or Password) and TenantId.
In Service connection name type azure subs. This name will be referenced in YAML pipelines to reference the service connection in order to access your Azure subscription.
Screenshot of the Azure service connection configuration.

Do not check Grant access permission to all pipelines. Select Verify and Save.

[!NOTE] The Grant access permission to all pipelines option is not recommended for production environments. It is only used in this lab to simplify the configuration of the pipeline.
You have now completed the necessary prerequisite steps to continue with the labs.