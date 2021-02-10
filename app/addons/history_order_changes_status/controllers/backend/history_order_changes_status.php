<?php

use Tygh\Registry;

if ($mode == 'manage') {
    $params = array_merge(
        array('items_per_page' => Registry::get('settings.Appearance.admin_elements_per_page')),
        $_REQUEST
    );

    $params['company_id'] = Registry::get('runtime.company_id');

    list($history_order_changes_status, $search) = fn_get_history_order_changes_status($params, DESCR_SL);
    $order_statuses = fn_get_statuses(STATUSES_ORDER);
    $responsibles = fn_call_requests_get_responsibles();

    Tygh::$app['view']
        ->assign('history_order_changes_status', $history_order_changes_status)
        ->assign('search', $search)
        ->assign('order_statuses', $order_statuses)
        ->assign('responsibles', $responsibles);

}
