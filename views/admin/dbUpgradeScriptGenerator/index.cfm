<cfscript>
	formId   = "datasource";
	formName = "dbupgradescriptgenerator.datasource";

	args.validationResult = args.validationResult ?: "";
</cfscript>

<cfoutput>
	<p class="alert alert-danger"><i class="fa fa-fw fa-exclamation-triangle"></i> #translateResource( "cms:dbupgradescriptgenerator.warning" )#</p>

	<form id="#formId#" data-auto-focus-form="true" data-dirty-form="protect" class="form-horizontal" method="post" action="">
		#renderForm(
			  formName         = formName
			, context          = "admin"
			, formId           = formId
			, validationResult = args.validationResult
		)#

		<div class="form-actions row">
			<div class="col-md-offset-2">
				<button class="btn btn-info" type="submit" tabindex="#getNextTabIndex()#">
					<i class="fa fa-check bigger-110"></i>
					#translateResource( "cms:dbupgradescriptgenerator.generate.btn" )#
				</button>
			</div>
		</div>
	</form>
</cfoutput>