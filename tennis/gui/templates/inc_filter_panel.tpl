{*
 * TestLink Open Source Project - http://testlink.sourceforge.net/
 * @filesource  inc_filter_panel.tpl
 *
 * Shows the filter panel. Included by some other templates.
 * At the moment: planTCNavigator, execNavigator, planAddTCNavigator, tcTree.
 * Inspired by idea in discussion regarding TICKET 3301.
 *
 * Naming conventions for variables are based on the names
 * used in plan/planTCNavigator.tpl.
 * That template was also the base for most of the html code used in here.
 *
 * @author Andreas Simon
 * @internal revisions
 *
 * @since 1.9.15
 *}

{lang_get var=labels s='caption_nav_settings, caption_nav_filters, platform, test_plan,
                        build,filter_tcID,filter_on,filter_result,status,
                        btn_update_menu,btn_apply_filter,keyword,keywords_filter_help,
                        filter_owner,TestPlan,test_plan,caption_nav_filters,
                        platform, include_unassigned_testcases, filter_active_inactive,
                        btn_remove_all_tester_assignments, execution_type, 
                        do_auto_update, testsuite, btn_reset_filters,hint_list_of_bugs,
                        btn_bulk_update_to_latest_version, priority, tc_title,
                        custom_field, search_type_like, importance,import_xml_results,
                        document_id, req_expected_coverage, title,bugs_on_context,
                        status, req_type, req_spec_type, th_tcid, has_relation_type,
                        btn_export_testplan_tree,btn_export_testplan_tree_for_results,
                        tester_works_with_settings,btn_bulk_remove,btn_bulk_copy'}

{config_load file="input_dimensions.conf" section="treeFilterForm"}

<form method="post" id="filter_panel_form" name="filter_panel_form"
      {if $control->formAction } action="{$control->formAction}" {/if}

      {if $control->filters.filter_result}
        onsubmit="return validateForm(this);document.getElementById('filter_result_method').disabled=false;"
      {/if}
        >
  <input type="hidden" name="caller" value="filter_panel">
          
{* hidden input with token to manage transfer of data between left and right frame *}
{if isset($control->form_token)}
  <input type="hidden" name="form_token" value="{$control->form_token}">
{/if}

{$platformID=0}

{if $control->draw_bulk_update_button}
<div class="text-center">
  <input class="btn btn-secondary" type="button" value="{$labels.btn_bulk_update_to_latest_version}"
         name="doBulkUpdateToLatest"
         onclick="update2latest({$gui->tPlanID})" />
</div>
  <br>
{/if}

{* hidden feature input (mainly for testcase edit when refreshing frame) *}
{if isset($gui->feature)}
<input type="hidden" id="feature" name="feature" value="{$gui->feature}" />
{/if}

{include file="inc_help.tpl" helptopic="hlp_executeFilter" show_help_icon=false}

{*
 * The settings are not configurable by the user.
 * They depend on the mode that is defined by the logic in *filterControl classes.
 *}

{* Need to redefine this ext-js style in order to make chosen work, changing overflow. 
   A div with this style is generated by EXT-JS functions regarding panel *}
<style type="text/css" media="all">
.x-panel-bwrap { overflow: visible; left: 0px; top: 0px; }    
</style>

{if $control->display_settings}
    <div class="card">
        <div class="card-header" >
            <h4 data-toggle="collapse" data-parent="#accordion" href="#collapse" class="card-title text-center collapsed" style="cursor: pointer" aria-expanded="false"> {$labels.caption_nav_settings}  <span class="glyphicon glyphicon-chevron-down"></span></h4>

        </div>
        <div id="collapse" class="collapse" style="display: none">
            <div id="settings" class="card-body">
                <input type='hidden' id="tpn_view_settings" name="tpn_view_status"  value="0" />

                <table class="table" style="width:98%;">
                    {if $control->settings.setting_testplan}
                        <tr>
                            <td>{$labels.test_plan}</td>
                            <td>
                                <select class="chosen-select form-control" name="setting_testplan" onchange="this.form.submit()">
                                    {html_options options=$control->settings.setting_testplan.items
                                    selected=$control->settings.setting_testplan.selected}
                                </select>
                            </td>
                        </tr>
                    {/if}
                    {if $control->settings.setting_platform}
                        {$platformID=$control->settings.setting_platform.selected}
                        <tr>
                            <td>{$labels.platform}</td>
                            <td>
                                <select name="setting_platform" class="chosen-select form-control" onchange="this.form.submit()">
                                    {html_options options=$control->settings.setting_platform.items
                                    selected=$control->settings.setting_platform.selected}
                                </select>
                            </td>
                        </tr>
                    {/if}
                    {if $control->settings.setting_build}
                        <tr>
                            <td>{$control->settings.setting_build.label}</td>
                            <td>
                                <select name="setting_build" class="chosen-select form-control" onchange="this.form.submit()">
                                    {html_options options=$control->settings.setting_build.items
                                    selected=$control->settings.setting_build.selected}
                                </select>
                            </td>
                        </tr>
                    {/if}
                    {if $control->settings.setting_refresh_tree_on_action}
                        <tr>
                            <td>{$labels.do_auto_update}</td>
                            <td>
                                <input type="hidden"
                                       id="hidden_setting_refresh_tree_on_action"
                                       name="hidden_setting_refresh_tree_on_action"
                                       value="{$control->settings.setting_refresh_tree_on_action.hidden_setting_refresh_tree_on_action}" />

                                <input type="checkbox"
                                       id="cbsetting_refresh_tree_on_action"
                                       name="setting_refresh_tree_on_action"
                                        {if $control->settings.setting_refresh_tree_on_action.selected} checked {/if}
                                       style="font-size: 90%;" onclick="this.form.submit()"/>
                            </td>
                        </tr>
                    {/if}
                    {if $control->draw_export_testplan_button || $control->draw_import_xml_results_button}
                        <tr>
                            <td>&nbsp;</td>
                            <td>
                                {if $control->draw_export_testplan_button}
                                    <image src="{$tlImages.export}" title="{$labels.btn_export_testplan_tree}"
                                           onclick="javascript: openExportTestPlan('export_testplan','{$session.testprojectID}',
                                                   '{$control->settings.setting_testplan.selected}','{$platformID}',
                                                   '{$control->settings.setting_build.selected}','tree',
                                                   '{$control->form_token}');" />
                                    &nbsp;
                                    <image src="{$tlImages.export_for_results_import}" title="{$labels.btn_export_testplan_tree_for_results}"
                                           onclick="javascript: openExportTestPlan('export_testplan','{$session.testprojectID}',
                                                   '{$control->settings.setting_testplan.selected}',
                                                   '{$platformID}',
                                                   '{$control->settings.setting_build.selected}','4results',
                                                   '{$control->form_token}');" />

                                    &nbsp;
                                {/if}
                                {if $control->draw_import_xml_results_button}
                                    <image src="{$tlImages.import_results}" title="{$labels.import_xml_results}"
                                           onclick="javascript: openImportResult('import_xml_results',{$session.testprojectID},
                                           {$control->settings.setting_testplan.selected},
                                           {$control->settings.setting_build.selected},{$platformID});" />
                                {/if}
                            </td>
                        </tr>
                    {/if}
                </table>
            </div> {* settings *}
        </div>

    </div> {* settings_panel *}
    <br>
{/if} {* display settings *}

{if $control->display_filters}
    <div class="card">
        <div class="card-header" >
            <h4 data-toggle="collapse" data-parent="#accordion" href="#collapse1" class="card-title text-center collapsed" style="cursor: pointer" aria-expanded="false"> {$labels.caption_nav_filters}  <span class="glyphicon glyphicon-chevron-down"></span></h4>
        </div>
        <div id="collapse1" class="collapse" style="display:none;">
            <div id="filters" class="card-body">


                <table class="table" style="width:98%;">
                    {if $control->filters.filter_tc_id}
                        <tr>
                            <td>{$labels.th_tcid}</td>
                            <td><input class="form-control" type="text" name="filter_tc_id"
                                       size="{#TC_ID_SIZE#}"
                                       maxlength="{#TC_ID_MAXLEN#}"
                                       value="{$control->filters.filter_tc_id.selected|escape}" />
                            </td>
                        </tr>
                    {/if}

                    {if $control->filters.filter_testcase_name}
                        <tr>
                            <td>{$labels.tc_title}</td>
                            <td><input class="form-control" type="text" name="filter_testcase_name"
                                       size="{#TC_TITLE_SIZE#}"
                                       maxlength="{#TC_TITLE_MAXLEN#}"
                                       value="{$control->filters.filter_testcase_name.selected|escape}" />
                            </td>
                        </tr>
                    {/if}

                    {if $control->filters.filter_toplevel_testsuite}
                        <tr>
                            <td>{$labels.testsuite}</td>
                            <td>
                                <select class="chosen-select form-control" name="filter_toplevel_testsuite">
                                    {html_options options=$control->filters.filter_toplevel_testsuite.items
                                    selected=$control->filters.filter_toplevel_testsuite.selected}
                                </select>
                            </td>
                        </tr>
                    {/if}

                    {if $control->filters.filter_keywords}
                        <tr>
                            <td>{$labels.keyword}</td>
                            <td><select class="chosen-select form-control" name="filter_keywords[]"
                                        title="{$labels.keywords_filter_help}"
                                        multiple="multiple"
                                        size="{$control->filters.filter_keywords.size}">
                                    {html_options options=$control->filters.filter_keywords.items
                                    selected=$control->filters.filter_keywords.selected}
                                </select>
                                <div>
                                    {html_radios name='filter_keywords_filter_type'
                                    options=$control->filters.filter_keywords.filter_keywords_filter_type.items
                                    selected=$control->filters.filter_keywords.filter_keywords_filter_type.selected}
                                </div>
                            </td>
                        </tr>
                        <tr><td>&nbsp;</td></tr>
                    {/if}

                    {* TICKET 4353: added filter for active/inactive test cases *}
                    {if isset($control->filters.filter_active_inactive) && $control->filters.filter_active_inactive}
                        <tr>
                            <td>{$labels.filter_active_inactive}</td>
                            <td>
                                <select class="form-control" name="filter_active_inactive">
                                    {html_options options=$control->filters.filter_active_inactive.items
                                    selected=$control->filters.filter_active_inactive.selected}
                                </select>
                            </td>
                        </tr>
                    {/if}

                    {if $control->filters.filter_workflow_status}
                        <tr>
                            <td>{$labels.status}</td>
                            <td>
                                <select class="chosen-select form-control" id="filter_workflow_status"
                                        {if $control->advanced_filter_mode}
                                        name="filter_workflow_status[]" multiple="multiple"
                                        size="{$control->filter_item_quantity}">
                                    {else}
                                    name="filter_workflow_status">
                                    {/if}
                                    {html_options options=$control->filters.filter_workflow_status.items
                                    selected=$control->filters.filter_workflow_status.selected}
                                </select>
                            </td>
                        </tr>
                    {/if}

                    {if $control->filters.filter_importance}
                        <tr>
                            <td>{$labels.importance}</td>
                            <td>
                                <select class="chosen-select form-control" id="filter_importance"
                                        {if $control->advanced_filter_mode}
                                        name="filter_importance[]" multiple="multiple"
                                        size="{$control->filters.filter_importance.size}">
                                    {else}
                                    name="filter_importance">
                                    {/if}
                                    {html_options options=$control->filters.filter_importance.items
                                    selected=$control->filters.filter_importance.selected}
                                </select>
                            </td>
                        </tr>
                    {/if}

                    {if $control->filters.filter_priority}
                        <tr>
                            <td>{$labels.priority}</td>
                            <td>
                                <select class="chosen-select form-control" name="filter_priority">
                                    <option value="">{$control->option_strings.any}</option>
                                    {html_options options=$gsmarty_option_importance
                                    selected=$control->filters.filter_priority.selected}
                                </select>
                            </td>
                        </tr>
                    {/if}

                    {if $control->filters.filter_execution_type}
                        <tr>
                            <td>{$labels.execution_type}</td>
                            <td>
                                <select class="chosen-select form-control" name="filter_execution_type">
                                    {html_options options=$control->filters.filter_execution_type.items
                                    selected=$control->filters.filter_execution_type.selected}
                                </select>
                            </td>
                        </tr>
                    {/if}

                    {if $control->filters.filter_assigned_user}
                        <tr>
                            <td>{$labels.filter_owner}<img src="{$tlImages.info_small}" title="{$labels.tester_works_with_settings}"></td>
                            <td>

                                {if $control->advanced_filter_mode}
                                    <select class="chosen-select form-control" name="filter_assigned_user[]"
                                            id="filter_assigned_user"
                                            multiple="multiple"
                                            size="{$control->filter_item_quantity}" >
                                        {html_options options=$control->filters.filter_assigned_user.items
                                        selected=$control->filters.filter_assigned_user.selected}
                                    </select>
                                {else}
                                    <select class="chosen-select form-control" name="filter_assigned_user"
                                            id="filter_assigned_user"
                                            onchange="triggerAssignedBox('filter_assigned_user',
                                                    'filter_assigned_user_include_unassigned',
                                                    '{$control->option_strings.any}',
                                                    '{$control->option_strings.none}',
                                                    '{$control->option_strings.somebody}');">
                                        {html_options options=$control->filters.filter_assigned_user.items
                                        selected=$control->filters.filter_assigned_user.selected}
                                    </select>

                                    <br/>
                                    <br />
                                    <input type="checkbox"
                                           id="filter_assigned_user_include_unassigned"
                                           name="filter_assigned_user_include_unassigned"
                                           value="1"
                                            {if $control->filters.filter_assigned_user.filter_assigned_user_include_unassigned}
                                                checked="checked"
                                            {/if}
                                    />
                                    {$labels.include_unassigned_testcases}
                                {/if}

                            </td>
                        </tr>
                    {/if}

                    {* 20131226 *}
                    {if $control->filters.filter_bugs}
                        <tr>
                            <td>{$labels.bugs_on_context}</td>
                            <td><input class="form-control" type="text" name="filter_bugs" size="{#BUGS_FILTER_SIZE#}"
                                       maxlength="{#BUGS_FILTER_MAXLEN#}"
                                       placeholder="{$labels.hint_list_of_bugs}"
                                       value="{$control->filters.filter_bugs.selected|escape}" />
                            </td>
                        </tr>
                    {/if}


                    {* custom fields are placed here *}

                    {if $control->filters.filter_custom_fields && !$control->filters.filter_custom_fields.collapsed}
                        <tr><td>&nbsp;</td></tr>
                        {$control->filters.filter_custom_fields.items}
                    {/if}


                    {* result filtering parts *}
                    {if $control->filters.filter_result}

                        <tr><td>&nbsp;</td></tr> {* empty row for a little separation *}

                        <tr>
                            <td>{$labels.filter_result}</td>
                            <td>
                                <select class="chosen-select form-control" id="filter_result_result"
                                        {if $control->advanced_filter_mode}
                                        name="filter_result_result[]" multiple="multiple"
                                        size="{$control->filter_item_quantity}">
                                    {else}
                                    name="filter_result_result">
                                    {/if}
                                    {html_options options=$control->filters.filter_result.filter_result_result.items
                                    selected=$control->filters.filter_result.filter_result_result.selected}
                                </select>
                            </td>
                        </tr>

                        <tr>
                            <td>{$labels.filter_on}</td>
                            <td>
                                <select class="chosen-select form-control" name="filter_result_method" id="filter_result_method"
                                        onchange="triggerBuildChooser('filter_result_build_row',
                                                'filter_result_method',
                                        {$control->configuration->filter_methods.status_code.specific_build});">
                                    {html_options options=$control->filters.filter_result.filter_result_method.items
                                    selected=$control->filters.filter_result.filter_result_method.selected}
                                </select>
                            </td>
                        </tr>

                        <tr id="filter_result_build_row">
                            <td>{$labels.build}</td>
                            <td><select class="chosen-select form-control" id="filter_result_build" name="filter_result_build">
                                    {html_options options=$control->filters.filter_result.filter_result_build.items
                                    selected=$control->filters.filter_result.filter_result_build.selected}
                                </select>
                            </td>
                        </tr>

                    {/if}


                </table>
                <br>
                <div class="text-center">
                    <input class="btn btn-info" type="submit"
                           value="{$labels.btn_apply_filter}"
                           id="doUpdateTree"
                           name="doUpdateTree"
                           style="font-size: 90%;" />

                    <input class="btn btn-secondary" type="submit"
                           value="{$labels.btn_reset_filters}"
                           id="doResetTree"
                           name="btn_reset_filters"
                           style="font-size: 90%;" />

                    {if $control->filters.filter_custom_fields}
                        <input class="btn btn-warning" type="submit"
                               value="{$control->filters.filter_custom_fields.btn_label}"
                               id="doToggleCF"
                               name="btn_toggle_cf"
                               style="font-size: 90%;" />
                    {/if}

                    {if $control->filter_mode_choice_enabled}

                        {if $control->advanced_filter_mode}
                            <input type="hidden" name="btn_advanced_filters" value="1" />
                        {/if}

                        <input class="btn btn-primary" type="submit" id="toggleFilterMode"  name="{$control->filter_mode_button_name}"
                               value="{$control->filter_mode_button_label}"
                               style="font-size: 90%;"  />
                    {/if}
                </div>
            </div> {* settings *}
        </div>

    </div>
    <br>

{/if} {* show filters *}

{* here the requirement part starts *}

{if $control->display_req_settings}
  <div class="card">
    <div class="card-header" >
        <h4 data-toggle="collapse" data-parent="#accordion" href="#collapse" class="card-title text-center collapsed" style="cursor: pointer" aria-expanded="false"> {$labels.caption_nav_settings}  <span class="glyphicon glyphicon-chevron-down"></span></h4>
    </div>
    <div id="collapse" class="collapse" style="display: none">
        <div id="settings" class="card-body">
            <input type='hidden' id="tpn_view_settings" name="tpn_view_status"  value="0" />

            <table class="smallGrey" style="width:98%;">

                {if $control->settings.setting_refresh_tree_on_action}
                    <tr>
                        <td class="text-secondary"><h5>{$labels.do_auto_update}</h5></td>
                        <td>
                            <input type="hidden"
                                   id="hidden_setting_refresh_tree_on_action"
                                   name="hidden_setting_refresh_tree_on_action"
                                   value="{$control->settings.setting_refresh_tree_on_action.hidden_setting_refresh_tree_on_action}" />

                            <input type="checkbox"
                                   id="cbsetting_refresh_tree_on_action"
                                   name="setting_refresh_tree_on_action"
                                    {if $control->settings.setting_refresh_tree_on_action.selected} checked {/if}
                                   style="font-size: 90%;" onclick="this.form.submit();" />
                        </td>
                    </tr>
                {/if}

            </table>
        </div> {* settings *}
    </div>

  </div> {* settings_panel *}
    <br>
{/if} {* display req settings *}

{if $control->display_req_filters}
    <div class="card">
        <div class="card-header" >
            <h4 data-toggle="collapse" data-parent="#accordion" href="#collapse1" class="card-title text-center collapsed" style="cursor: pointer" aria-expanded="false"> {$labels.caption_nav_filters}  <span class="glyphicon glyphicon-chevron-down"></span></h4>
        </div>
        <div id="collapse1" class="collapse" style="display: none">
            <div id="filters" class="card-body">


                    <table class="table" style="width:98%;">

                        {if $control->filters.filter_doc_id}
                            <tr>
                                <td>{$labels.document_id}</td>
                                <td><input class="form-control" type="text" name="filter_doc_id"
                                           size="{#REQ_DOCID_SIZE#}"
                                           maxlength="{#REQ_DOCID_MAXLEN#}"
                                           value="{$control->filters.filter_doc_id.selected|escape}" />
                                </td>
                            </tr>
                        {/if}

                        {if $control->filters.filter_title}
                            <tr>
                                <td>{$labels.title}</td>
                                <td><input class="form-control" type="text" name="filter_title"
                                           size="{#REQ_NAME_SIZE#}"
                                           maxlength="{#REQ_NAME_MAXLEN#}"
                                           value="{$control->filters.filter_title.selected|escape}" />
                                </td>
                            </tr>
                        {/if}

                        {if $control->filters.filter_status}
                            <tr>
                                <td>{$labels.status}</td>
                                <td>
                                    <select  class="chosen-select form-control" id="filter_status"
                                            {if $control->advanced_filter_mode}
                                            name="filter_status[]"
                                            multiple="multiple"
                                            size="{$control->filter_item_quantity}" >
                                        {else}
                                        name="filter_status">
                                        {/if}
                                        {html_options options=$control->filters.filter_status.items
                                        selected=$control->filters.filter_status.selected}
                                    </select>

                                </td>
                            </tr>
                        {/if}

                        {if $control->filters.filter_type}
                            <tr>
                                <td>{$labels.req_type}</td>
                                <td>
                                    <select class="chosen-select form-control" id="filter_type"
                                            {if $control->advanced_filter_mode}
                                            name="filter_type[]"
                                            multiple="multiple"
                                            size="{$control->filter_item_quantity}" >
                                        {else}
                                        name="filter_type">
                                        {/if}
                                        {html_options options=$control->filters.filter_type.items
                                        selected=$control->filters.filter_type.selected}
                                    </select>
                                </td>
                            </tr>
                        {/if}

                        {if $control->filters.filter_spec_type}
                            <tr>
                                <td>{$labels.req_spec_type}</td>
                                <td>
                                    <select class="chosen-select form-control" id="filter_spec_type"
                                            {if $control->advanced_filter_mode}
                                            name="filter_spec_type[]"
                                            multiple="multiple"
                                            size="{$control->filter_item_quantity}" >
                                        {else}
                                        name="filter_spec_type">
                                        {/if}
                                        {html_options options=$control->filters.filter_spec_type.items
                                        selected=$control->filters.filter_spec_type.selected}
                                    </select>
                                </td>
                            </tr>
                        {/if}

                        {if $control->filters.filter_coverage}
                            <tr>
                                <td>{$labels.req_expected_coverage}</td>
                                <td><input class="form-control" type="text" name="filter_coverage"
                                           size="{#COVERAGE_SIZE#}"
                                           maxlength="{#COVERAGE_MAXLEN#}"
                                           value="{$control->filters.filter_coverage.selected|escape}" />
                                </td>
                            </tr>
                        {/if}

                        {if $control->filters.filter_relation}
                            <tr>
                                <td>{$labels.has_relation_type}</td>
                                <td>
                                    <select class="chosen-select form-control" id="filter_relation"
                                            {if $control->advanced_filter_mode}
                                            name="filter_relation[]"
                                            multiple="multiple"
                                            size="{$control->filter_item_quantity}" >
                                        {else}
                                        name="filter_relation">
                                        {/if}
                                        {html_options options=$control->filters.filter_relation.items
                                        selected=$control->filters.filter_relation.selected}
                                    </select>
                                </td>
                            </tr>
                        {/if}

                        {if $control->filters.filter_tc_id}
                            <tr>
                                <td>{$labels.th_tcid}</td>
                                <td><input class="form-control" type="text" name="filter_tc_id"
                                           size="{#TC_ID_SIZE#}"
                                           maxlength="{#TC_ID_MAXLEN#}"
                                           value="{$control->filters.filter_tc_id.selected|escape}" />
                                </td>
                            </tr>
                        {/if}

                        {if $control->filters.filter_custom_fields && !$control->filters.filter_custom_fields.collapsed}
                            <tr><td>&nbsp;</td></tr>
                            {$control->filters.filter_custom_fields.items}
                        {/if}

                    </table>
                <br>
                    <div class="text-center">
                        <input class="btn btn-success" type="submit"
                               value="{$labels.btn_apply_filter}"
                               id="doUpdateTree"
                               name="doUpdateTree"
                               style="font-size: 90%;" />

                        <input class="btn btn-secondary" type="submit"
                               value="{$labels.btn_reset_filters}"
                               id="doResetTree"
                               name="btn_reset_filters"
                               style="font-size: 90%;" />

                        {if $control->filters.filter_custom_fields}
                            <input class="btn btn-info" type="submit"
                                   value="{$control->filters.filter_custom_fields.btn_label}"
                                   id="doToggleCF"
                                   name="btn_toggle_cf"
                                   style="font-size: 90%;" />
                        {/if}

                        {if $control->filter_mode_choice_enabled}

                            {if $control->advanced_filter_mode}
                                <input type="hidden" name="btn_advanced_filters" value="1" />
                            {/if}

                            <input class="btn btn-info" type="submit" id="toggleFilterMode"  name="{$control->filter_mode_button_name}"
                                   value="{$control->filter_mode_button_label}"
                                   style="font-size: 90%;"  />
                        {/if}

                    </div>
            </div> {* settings *}
        </div>

    </div>
    <br>
{/if} {* show requirement filters *}
<div class="text-center">
    {if $control->draw_tc_unassign_button}
        <input class="btn btn-danger" type="button" style="font-size: 90%;"
               name="removen_all_tester_assignments"
               value="{$labels.btn_bulk_remove}"
               onclick="delete_testers_from_build({$control->settings.setting_build.selected});"
        />
    {/if}
    {if $control->draw_tc_assignment_bulk_copy_button}
        <input class="btn btn-warning" type="button" style="font-size: 90%;"
               name="copy_tester_assignments"
               value="{$labels.btn_bulk_copy}"
               onclick="copy_tester_assignments_from_build({$control->settings.setting_build.selected});"
        />
    {/if}
</div>

</form>