# akeyless-dba-workflow-tf-example
## What this does
This Repo creates uses github actions to dynamically generate aws credentials that the terraform provider can use to build out resources in the AWS environment the credentials are created for.  
## Preqruistes
1. AWS Environment
2. [A Backend to store state.](https://medium.com/@surangajayalath299/what-is-terraform-backend-how-used-it-ea5b36f08396) 
4. Akeyless Gateway
5. Akeyless Dynamic Secret: This will generate the aws credentials that will last the length of the terraform build. Docs are below: 
- [AWS Dynamic Secrets](https://www.akeyless.io/secrets-management-glossary/dynamic-secrets/) 
- [AWS Producer](https://docs.akeyless.io/docs/aws-producer)

    1. Akeyless Target: A target is required to create a Akeyless Dynamic Secret
    - (https://docs.akeyless.io/docs/aws-targets)
    - This target will also require the correct permission for the Terraform resources being created
5. Permissions to create a Akeyless Jwt Authentication Method



## AKeyless Setup

### Authentication Methods

This action only supports authenticating to AKeyless via JWT auth (using the GitHub OIDC token) or via IAM Auth (using a role attached to a cloud-hosted GitHub runner).  I don't plan to support additional authentication methods because there isn't much point (with the possible exception of Universal Identity).  After all, any runner can login to AKeyless using OIDC without storing permanent access credentials.  IAM auth is also supported in case you are using a runner hosted in your cloud account and so are already using IAM auth anyway - this will also give your runner access to AKeyless without storing permanent access credentials.

### Setting up JWT Auth

To configure AKeyless and grant your repositories the necessary permissions to execute this action:

1. Create a GitHub JWT Auth method in AKeyless if you don't have one (you can safely share the auth method between repositories)
    1. In AKeyless go to "Auth Methods" -> "+ New" -> "OAuth 2.0/JWT".
    2. Specify a name (e.g. "GitHub JWT Auth") and location of your choice.
    3. For the JWKS Url, specify `https://token.actions.githubusercontent.com/.well-known/jwks`
    4. For the unique identifier use `repository`. See note (1) below for more details.
    5. You **MUST** click "Require Sub Claim on role association".  This will prevent you from attaching this to a role without any additional checks. If you accidentally forgot to set subclaim checks, then any GitHub runner owned by *anyone* would be able to authenticate to AKeyless and access your resources... **that make this a critical checkbox**.  See the [GitHub docs](https://docs.GitHub.com/en/actions/deployment/security-hardening-your-deployments/about-security-hardening-with-openid-connect#configuring-the-oidc-trust-with-the-cloud) for more details.
2. Create an appropriate access role (if you don't already have one)
    1. In AKeyless go to "Access Roles" -> "+ New"
    2. Give it a name and location, and create it.
    3. Find your new access role and click on it to edit it.
    4. On the right side, under "Secrets & Keys", click the "Add" button to configure read access to any static or dynamic secrets you will fetch from your pipeline.
3. Attach your GitHub JWT Auth method to your role
    1. Once again, find the access role you created in step #2 above and click on it to edit it.
    2. Hit the "+ Associate" button to associate your "GitHub JWT Auth" method with the role.
    3. In the list, find the auth method you created in Step #1 above.
    4. Add an appropriate sub claim, based on [the claims available in the JWT](https://docs.GitHub.com/en/actions/deployment/security-hardening-your-deployments/about-security-hardening-with-openid-connect#understanding-the-oidc-token). See note (2) below for more details.
    5. Save!

After following these steps, you'll be ready to use JWT Auth from your GitHub runners!

**(1) Note:** The unique identifier is mainly used for auditing/billing purposes, so there isn't one correct answer here.  `repository` is a sensible default but if you are uncertain, talk to AKeyless for more details.

**(2) Note:** Subclaim checks allow AKeyless to grant access to specific workflows, based on the claims that GitHub provides in the JWT.  Using the example JWT from [the documentation](https://docs.GitHub.com/en/actions/deployment/security-hardening-your-deployments/about-security-hardening-with-openid-connect#understanding-the-oidc-token), you could set a subclaim check in AKeyless (using example below) to limit access to workflows that were triggered from the main branch in the `octo-org/octo-repo` repository.:

```
repository=octo-org/octo-repo
ref=refs/heads/main
```
