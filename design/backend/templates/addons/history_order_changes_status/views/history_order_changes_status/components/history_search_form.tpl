<div class="sidebar-row">
    <h6>{__("search")}</h6>

    {if $page_part}

        {$_page_part = "#`$page_part`"}

    {/if}
    <form action="{""|fn_url}{$_page_part}" name="orders_search_form" method="get" class="cm-disable-empty {$form_meta}">

    {capture name="simple_search"}

        {if $smarty.request.redirect_url}

            <input type="hidden" name="redirect_url" value="{$smarty.request.redirect_url}" />

        {/if}

        {if $selected_section != ""}

            <input type="hidden" id="selected_section" name="selected_section" value="{$selected_section}" />

        {/if}

        {$extra nofilter}

        <div class="sidebar-field">
            <label>{__("history_order_changes_status.id_order")}</label>
            <input type="text" name="order_id" size="20" value="{$search.order_id}" />
        </div>
        <div class="control-group">
            <label for="user_id" class="control-label">{__("history_order_changes_status.changed_by")}</label>
            <div class="controls">
                <select name="user_id" id="user_id">
                    <option value="">--</option>
                    {foreach from=$responsibles key=user_id item=name}
                        <option value="{$user_id}" {if $search.user_id == $user_id}selected="selected"{/if}>{$name}</option>
                    {/foreach}
                </select>
            </div>
        </div>
        <div class="group">
            <div class="control-group">
                {hook name="history_order_changes_status:search_form"}
                {/hook}
            </div>
        </div>

    {/capture}

    {include file="common/advanced_search.tpl" simple_search=$smarty.capture.simple_search advanced_search=$smarty.capture.advanced_search dispatch="history_order_changes_status.manage" view_type="orders"}
    </form>
</div><hr>
