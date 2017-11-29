{*
TestLink Open Source Project - http://testlink.sourceforge.net/
@filesource inc_steps.tpl
            Shows the steps for a testcase in horizontal layout

@used-by inc_steps.tpl

@param $steps Array of the steps
@param $edit_enabled Steps links to edit page if true

@internal revisions
*}
{if isset($add_exec_info) && $add_exec_info}
    {$inExec = 1}
{else}
    {$inExec = 0}
{/if}
<thead class="bg-primary">
<tr>
  <th>{if $edit_enabled && $steps != '' && !is_null($steps)}
      <img class="clickable" src="{$tlImages.reorder}" align="left"
           title="{$inc_steps_labels.show_hide_reorder}"
           onclick="showHideByClass('span','order_info');">
      <img class="clickable" src="{$tlImages.ghost_item}" align="left"
           title="{$inc_steps_labels.show_ghost_string}"
           onclick="showHideByClass('p','ghost');">
      {/if}
      {$inc_steps_labels.step_number}
  </th>
  <th>{$inc_steps_labels.step_actions}</th>
  <th>{$inc_steps_labels.expected_results}</th>
    {if $session['testprojectOptions']->automationEnabled}
      <th width="25">{$inc_steps_labels.execution_type_short_descr}</th>
    {/if}
    {if $edit_enabled}
      <th>Actions</th>
    {/if}
    {if $inExec}
      <th>{if $tlCfg->exec_cfg->steps_exec_notes_default == 'latest'}{$inc_steps_labels.latest_exec_notes}
          {else}{$inc_steps_labels.step_exec_notes}{/if}
        <img class="clickable" src="{$tlImages.clear_notes}"
             onclick="clearTextAreaByClassName('step_note_textarea');" title="{$inc_steps_labels.clear_all_notes}"></th>

      <th>{$inc_steps_labels.step_exec_status}
        <img class="clickable" src="{$tlImages.reset}"
             onclick="clearSelectByClassName('step_status');" title="{$inc_steps_labels.clear_all_status}"></th>
    {/if}
</tr>
</thead>
<tbody>
{$rowCount=$steps|@count}
{$row=0}

{$att_ena = $inExec &&
$tlCfg->exec_cfg->steps_exec_attachments}
{foreach from=$steps item=step_info}
    <tr id="step_row_{$step_info.step_number}">
        <td >
      <span class="order_info" style='display:none'>
      {if $edit_enabled}
          <input type="text" class="step_number{$args_testcase.id}" name="step_set[{$step_info.id}]" id="step_set_{$step_info.id}"
                 value="{$step_info.step_number}"
                 size="{#STEP_NUMBER_SIZE#}"
                 maxlength="{#STEP_NUMBER_MAXLEN#}">
          {include file="error_icon.tpl" field="step_number"}
      {/if}
      </span>
            {$step_info.step_number}
        </td>

        <td {if $edit_enabled} style="cursor:pointer;" onclick="launchEditStep({$step_info.id})" {/if}>
            {if $gui->stepDesignEditorType == 'none'}{$step_info.actions|nl2br}{else}{$step_info.actions}{/if}
            {if $ghost_control}
                <p class='ghost' style='display:none'> {$step_info.ghost_result}</p>
            {/if}
        </td>
        <td {if $edit_enabled} style="cursor:pointer;" onclick="launchEditStep({$step_info.id})" {/if}>
            {if $gui->stepDesignEditorType == 'none'}{$step_info.expected_results|nl2br}{else}{$step_info.expected_results}{/if}

            {if $ghost_control}
                <p class='ghost' style='display:none'>{$step_info.ghost_result}</p>
            {/if}
        </td>

        {if $session['testprojectOptions']->automationEnabled}
            <td {if $edit_enabled} style="cursor:pointer;" onclick="launchEditStep({$step_info.id})" {/if}>{$gui->execution_types[$step_info.execution_type]}</td>
        {/if}

        {if $edit_enabled}
            <td>
                <a href="javascript:launchInsertStep({$step_info.id});"><i class="fa fa-plus-circle text-success"> {$inc_steps_labels.insert_step}</i></a><br>
                <a href="javascript:delete_confirmation({$step_info.id},'{$step_info.step_number|escape:'javascript'|escape}','{$del_msgbox_title}','{$warning_msg}');" title="{$inc_steps_labels.delete_step}"><i class="fa fa-minus-circle text-danger"> {$inc_steps_labels.delete_step}</i></a>

            </td>
        {/if}

        {if $inExec}
            <td class="exec_tcstep_note">
        <textarea class="step_note_textarea form-control" name="step_notes[{$step_info.id}]" id="step_notes_{$step_info.id}"
                  cols="40" rows="5">{$step_info.execution_notes|escape}</textarea>
            </td>

            <td>
                <select class="step_status form-control" name="step_status[{$step_info.id}]" id="step_status_{$step_info.id}">
                    {html_options options=$gui->execStatusValues selected=$step_info.execution_status}

                </select> <br>

                {if $gui->tlCanCreateIssue}
                    {include file="execute/add_issue_on_step.inc.tpl"
                    args_labels=$labels
                    args_step_id=$step_info.id}
                {/if}
            </td>

        {/if}

    </tr>
    {if $inExec && $gui->tlCanCreateIssue}
        <tr>
            <td colspan=6>
                {include file="execute/issue_inputs_on_step.inc.tpl"
                args_labels=$labels
                args_step_id=$step_info.id}
            </td>
        </tr>
    {/if}

    {if $gui->allowStepAttachments && $att_ena}
        <tr>
            <td colspan=6>
                {include file="attachments_simple.inc.tpl" attach_id=$step_info.id}
            </td>
        </tr>
    {/if}

    {$rCount=$row+$step_info.step_number}
    {if ($rCount < $rowCount) && ($rowCount>=1)}
        <tr style="display: none;">
            {if $session['testprojectOptions']->automationEnabled}
            <td colspan=6>
                {else}
            <td colspan=5>
                {/if}
            </td>
        </tr>
    {/if}

{/foreach}
</tbody>


