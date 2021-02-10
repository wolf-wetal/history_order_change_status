{capture name="mainbox"}

    <form action="{""|fn_url}" method="post" name="manage_history_order_changes_status_form" class="form-horizontal form-edit cm-ajax">
        <input type="hidden" name="result_ids" value="pagination_contents,tools_history_order_changes_status_buttons" />

        {include file="common/pagination.tpl" save_current_page=true save_current_url=true div_id=$smarty.request.content_id}

        {assign var="return_url" value=$config.current_url|escape:"url"}
        {assign var="c_url" value=$config.current_url|fn_query_remove:"sort_by":"sort_order"}

        {assign var="rev" value=$smarty.request.content_id|default:"pagination_contents"}
        {assign var="c_icon" value="<i class=\"icon-`$search.sort_order_rev`\"></i>"}
        {assign var="c_dummy" value="<i class=\"icon-dummy\"></i>"}

        {if $history_order_changes_status}
            <div class="table-responsive-wrapper">
                <table width="100%" class="table table-middle table-responsive">
                    <thead>
                    <tr>
                        <th width="10%">
                            <a class="cm-ajax" href="{"`$c_url`&sort_by=id&sort_order=`$search.sort_order_rev`"|fn_url}" data-ca-target-id={$rev}>{__("history_order_changes_status.id_order")}{if $search.sort_by == "id"}{$c_icon nofilter}{else}{$c_dummy nofilter}{/if}</a>

                        <th width="20%">
                            <a class="cm-ajax" href="{"`$c_url`&sort_by=status_old&sort_order=`$search.sort_order_rev`"|fn_url}" data-ca-target-id={$rev}>{__("history_order_changes_status.status_old")}{if $search.sort_by == "status_old"}{$c_icon nofilter}{else}{$c_dummy nofilter}{/if}</a>
                        </th>
                        <th width="20%">
                            <a class="cm-ajax" href="{"`$c_url`&sort_by=status_new&sort_order=`$search.sort_order_rev`"|fn_url}" data-ca-target-id={$rev}>{__("history_order_changes_status.status_new")}{if $search.sort_by == "status_new"}{$c_icon nofilter}{/if}</a>
                        </th>
                        <th width="25%">
                            <a class="cm-ajax" href="{"`$c_url`&sort_by=changed_by&sort_order=`$search.sort_order_rev`"|fn_url}" data-ca-target-id={$rev}>{__("history_order_changes_status.changed_by")}{if $search.sort_by == "changed_by"}{$c_icon nofilter}{/if}</a>
                        </th>
                        <th width="30%">
                            <a class="cm-ajax" href="{"`$c_url`&sort_by=change_date&sort_order=`$search.sort_order_rev`"|fn_url}" data-ca-target-id={$rev}>{__("history_order_changes_status.change_date")}{if $search.sort_by == "change_date"}{$c_icon nofilter}{else}{$c_dummy nofilter}{/if}</a>
                        </th>
                    </tr>
                    {foreach from=$history_order_changes_status item=request}
                    <tbody class="cm-row-item">
                    <tr class="cm-row-status-{$request.order_id|lower}">
                        <td data-th="{__("id")}">
                            <a href="{fn_url("orders.details?order_id={$request.order_id}")}">{$request.order_id}
                        </td>
                        <td data-th="{__("history_order_changes_status.status_old")}">
                            {$order_statuses[$request.status_old].description}
                        </td>
                        <td data-th="{__("history_order_changes_status.status_new")}">
                            {$order_statuses[$request.status_new].description}
                        </td>
                        <td data-th="{__("history_order_changes_status.changed_by")}">
                            {foreach from=$responsibles item=name key=user_id}
                            <a href="{fn_url("profiles.update&user_id={$request.user_id}")}">{$name}
                            {/foreach}
                        </td>
                        <td data-th="{__("date")}">{$request.timestamp|date_format:"`$settings.Appearance.date_format`, `$settings.Appearance.time_format`"}
                        </td>

                    </tr>
                    </tbody>
                    {/foreach}
                    </thead>
                </table>
            </div>
        {else}
            <p class="no-items">{__("no_data")}</p>
        {/if}

        <div class="clearfix">
            {include file="common/pagination.tpl" div_id=$smarty.request.content_id}
        </div>

    </form>

{/capture}

{capture name="sidebar"}
    {include file="common/saved_search.tpl" dispatch="history_order_changes_status.manage" view_type="history_order_changes_status"}
    {include file="addons/history_order_changes_status/views/history_order_changes_status/components/history_search_form.tpl" dispatch="history_order_changes_status.manage"}
{/capture}

{include file="common/mainbox.tpl"
    title=__("history_order_changes_status.name")
    content=$smarty.capture.mainbox
    sidebar=$smarty.capture.sidebar
    content_id="manage_history_order_changes_status"
}

