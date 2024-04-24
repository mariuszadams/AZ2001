# Configure a project and repository structure to support secure pipelines

In this lab, you will learn how to configure a project and repository structure in Azure DevOps to support secure pipelines. This lab covers best practices for organizing projects and repositories, assigning permissions, and managing secure files.

These exercises take approximately 30 minutes.

## Before you start

You'll need an Azure subscription, Azure DevOps organization, and the eShopOnWeb application to follow the labs.
Follow the steps to validate your lab environment.

## Instructions

### Exercise 1: Configure a secure project structure

In this exercise, you will configure a secure project structure by creating a new project and assigning it project permissions. Separating responsibilities and resources into different projects or repositories with specific permissions supports security.

#### Task 1: Create a new team project

Navigate to the Azure DevOps portal at https://dev.azure.com and open your organization.

Open your organization settings at the bottom left corner of the portal and then Projects under the General section.

Select the New Project option and use the following settings:

name: eShopSecurity
visibility: Private
Advanced: Version Control: Git
Advanced: Work Item Process: Scrum
Screenshot of the new project dialog with the specified settings.

Select Create to create the new project.

You can now switch between the different projects by clicking on the Azure DevOps icon in the upper left corner of the Azure DevOps portal.

Screenshot of the Azure DevOps team projects eShopOnWeb and eShopSecurity.

You can manage permissions and settings for each project separately by going to the Project settings menu and selecting the appropriate team project. If you have multiple users or teams working on different projects, you can also assign permissions to each project separately.

#### Task 2: Create a new repository and assign project permissions

Select the organization name in the upper left corner of the Azure DevOps portal and select the new eShopSecurity project.

Select the Repos menu.

Select the Initialize button to initialize the new repository by adding the README.md file.

Open the Project settings menu in the lower left corner of the portal and select Repositories under the Repos section.

Select the new eShopSecurity repository and select the Security tab.

Remove the Inherit permissions from parent by unchecking the Inheritance toggle button.

Select the Contributors group and select the Deny dropdown for all permissions except Read. This will prevent all users from the Contributors group from accessing the repository.

Select your user under Users and select the Allow button to allow all permissions.

[!NOTE] If you don't see your name in the Users section, enter your name in the Search for users or groups text box and select it in the list of results.

Screenshot of the repository security settings with allow for read and deny for all other permissions.

Your changes will be saved automatically.
Now only the user you assigned permissions and the administrators can access the repository. This is useful when you want to allow specific users to access the repository and run pipelines from the eShopOnWeb project.

### Exercise 2: Configure a pipeline and template structure to support secure pipelines

#### Task 1: Import and run the CI pipeline

Navigate to the Azure DevOps portal at https://dev.azure.com and open your organization.

Open the eShopOnWeb project in Azure DevOps.

Go to Pipelines > Pipelines.

Select the Create Pipeline button.

Select Azure Repos Git (Yaml).

Select the eShopOnWeb repository.

Select Existing Azure Pipelines YAML File.

Select the /.ado/eshoponweb-ci.yml file then select Continue.

Select the Run button to run the pipeline.

[!NOTE] Your pipeline will take a name based on the project name. You will rename it to easier identify the pipeline.
Go to Pipelines > Pipelines and select the recently created pipeline. Select the ellipsis and then select Rename/move option.

Name it eshoponweb-ci and select Save.

#### Task 2: Import and run the CD pipeline

Go to Pipelines > Pipelines.

Select New pipeline button.

Select Azure Repos Git (Yaml).

Select the eShopOnWeb repository.

Select Existing Azure Pipelines YAML File.

Select the /.ado/eshoponweb-cd-webapp-code.yml file then select Continue.

In the YAML pipeline definition under the variables section, customize:

AZ400-EWebShop-NAME with the name of your preference, for example, rg-eshoponweb-secure.
Location with the name of the Azure region you want to deploy your resources, for example, southcentralus.
YOUR-SUBSCRIPTION-ID with your Azure subscription id.
az400-webapp-NAME with a globally unique name of the web app to be deployed, for example, the string eshoponweb-lab-secure- followed by a random six-digit number.
Select Save and Run and choose to commit directly to the main branch.

Select Save and Run again.

Open the pipeline run. If you see the message "This pipeline needs permission to access a resource before this run can continue to Deploy to WebApp", select View, Permit and Permit again. This is needed to allow the pipeline to create the Azure App Service resource.

Screenshot of the permit access from the YAML pipeline.

The deployment may take a few minutes to complete, wait for the pipeline to execute. The pipeline is triggered following the completion of the CI pipeline and it includes the following tasks:

AzureResourceManagerTemplateDeployment: Deploys the Azure App Service web app using bicep template.
AzureRmWebAppDeployment: Publishes the Web site to the Azure App Service web app.
Your pipeline will take a name based on the project name. Let's rename it for identifying the pipeline better.

Go to Pipelines > Pipelines and select the recently created pipeline. Select the ellipsis and then select Rename/move option.

Name it eshoponweb-cd-webapp-code and select Save.

Now you should have two pipelines running in your eShopOnWeb project.

Screenshot of the successful executed CI/CD pipelines.

#### Task 3: Move the CD pipeline variables to a YAML template

In this task, you will create a YAML template to store the variables used in the CD pipeline. This will allow you to reuse the template in other pipelines.

Go to Repos and then Files.

Expand the .ado folder and select New file.

Name the file eshoponweb-secure-variables.yml and select Create.

Add the variables section used in the CD pipeline to the new file. The file should look like the following:

yaml
   variables:
     resource-group: 'rg-eshoponweb-secure'
     location: 'southcentralus' #the name of the Azure region you want to deploy your resources
     templateFile: 'infra/webapp.bicep'
     subscriptionid: 'YOUR-SUBSCRIPTION-ID'
     azureserviceconnection: 'azure subs' #the name of the service connection to your Azure subscription
     webappname: 'eshoponweb-lab-secure-XXXXXX' #the globally unique name of the web app
[!IMPORTANT] Replace the values of the variables with the values of your environment (resource group, location, subscription ID, Azure service connection, and web app name).
Select Commit, in the commit comment text box, enter [skip ci], and then select Commit.
[!NOTE] By adding the [skip ci] comment to the commit, you will prevent automatic pipeline execution, which, at this point, runs by default following every change to the repo.
From the list of files in the repo, open the eshoponweb-cd-webapp-code.yml pipeline definition, and replace the variables section with the following:
yaml
   variables:
     - template: eshoponweb-secure-variables.yml
Select Commit, accept the default comment, and then select Commit to run the pipeline again.

Verify that the pipeline run completed successfully.

Now you have a YAML template with the variables used in the CD pipeline. You can reuse this template in other pipelines in scenarios where you need to deploy the same resources. Also, your operations team can control the resource group and location where the resources are deployed and other information in your template values and you don't need to make any changes to your pipeline definition.

#### Task 4: Move the YAML templates to a separate repository and project

In this task, you will move the YAML templates to a separate repository and project.

In your eShopSecurity project, go to Repos > Files.

Create a new file named eshoponweb-secure-variables.yml.

Copy the content of the file .ado/eshoponweb-secure-variables.yml from the eShopOnWeb repository to the new file.

Commit the changes.

Open the eshoponweb-cd-webapp-code.yml pipeline definition in the eShopOnWeb repo.

Add the following to the resources section:

yaml
     repositories:
       - repository: eShopSecurity
         type: git
         name: eShopSecurity/eShopSecurity #name of the project and repository
Replace the variables section with the following:
yaml
   variables:
     - template: eshoponweb-secure-variables.yml@eShopSecurity #name of the template and repository

Screenshot of the pipeline definition with the new variables and resource sections.

Select Commit, accept the default comment, and then select Commit to run the pipeline again.

Navigate to the pipeline run and verify that the pipeline is using the YAML file from the eShopSecurity repository.

Screenshot of the pipeline execution using the YAML template from the eShopSecurity repository.

Now you have the YAML file in a separate repository and project. You can reuse this file in other pipelines in scenarios where you need to deploy the same resources. Also, your operations team can control the resource group, location, security and where the resources are deployed and other information by modifying values in the YAML file and you don't need to make any changes to your pipeline definition.

### Exercise 3: Perform cleanup of Azure and Azure DevOps resources

In this exercise, you will remove Azure and Azure DevOps resources created in this lab.

#### Task 1: Remove Azure resources

In the Azure portal, navigate to the resource group rg-eshoponweb-secure containing deployed resources and select Delete resource group to delete all resources created in this lab.

Screenshot of the delete resource group button.

[!WARNING] Always remember to remove any created Azure resources that you no longer use. Removing unused resources ensures you will not see unexpected charges.
#### Task 2: Remove Azure DevOps pipelines

Navigate to the Azure DevOps portal at https://dev.azure.com and open your organization.

Open the eShopOnWeb project.

Go to Pipelines > Pipelines.

Go to Pipelines > Pipelines and delete the existing pipelines.

#### Task 3: Recreate the Azure DevOps repo

In the Azure DevOps portal, in the eShopOnWeb project, select Project settings in the lower left corner.

In the Project settings vertical menu on the left side, in the Repos section, select Repositories.

In the All Repositories pane, hover over the far-right end of the eShopOnWeb repo entry until the More options ellipsis icon appears, select it, and, in the More option menu, select Rename.

In the Rename the eShopOnWeb repository window, in the Repository name text box, enter eShopOnWeb_old and select Rename.

Back in the All Repositories pane, select + Create.

In the Create a repository pane, in the Repository name text box, enter eShopOnWeb, uncheck the Add a README checkbox, and select Create.

Back in the All Repositories pane, hover over the far right end of the eShopOnWeb_old repo entry until the More options ellipsis icon appears, select it, and, in the More option menu, select Delete.

In the Delete eShopOnWeb_old repository window, enter eShopOnWeb_old and select Delete.

In the left navigational menu of the Azure DevOps portal, select Repos.

In the eShopOnWeb is empty. Add some code! pane, select Import a repository.

On the Import a Git Repository window, paste the following URL https://github.com/MicrosoftLearning/eShopOnWeb and select Import:

## Review

In this lab, you learned how to configure and organize a secure project and repository structure in Azure DevOps. By managing permissions effectively, you can ensure that the right users have access to the resources they need while maintaining the security and integrity of your DevOps pipelines and processes.

Congratulations!

You have successfully completed this Lab. Click Next to advance to the next Lab.