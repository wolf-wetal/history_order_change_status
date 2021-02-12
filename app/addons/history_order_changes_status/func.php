<?php

use Tygh\Navigation\LastView;

if (!defined('BOOTSTRAP')) { die('Access denied'); }

function fn_save_history_order_changes_status ($order_id, $user_id, $status_old, $status_new, $timestamp = TIME)
{
    $data = db_query("INSERT INTO ?:history_order_changes_status SET ?u", array(
        'order_id' => $order_id,
        'user_id' => $user_id,
        'status_old' => $status_old,
        'status_new' => $status_new,
        'timestamp' => $timestamp
    ));

    return $data;
}

function fn_get_history_order_changes_status($params = array(), $lang_code = CART_LANGUAGE)
{
    // Init filter
    $params = LastView::instance()->update('history_order_changes_status', $params);

    $params = array_merge(array(
        'items_per_page' => 0,
        'page' => 1,
    ), $params);

    $fields = array(
        'h.*',
        'o.status as order_status',
    );

    $joins = array(
        db_quote("LEFT JOIN ?:users u USING(user_id)"),
        db_quote("LEFT JOIN ?:orders o USING(order_id)")
    );

    $sortings = array (
        'id' => 'h.history_id',
        'date' => 'h.timestamp',
        'status_old' => 'h.status_old',
        'status_new' => 'h.status_new',
        'user_id' => 'h.user_id',
        'user' => array('u.lastname', 'u.firstname'),
        'order' => 'h.order_id',
        'order_status' => 'o.status',
    );

    $condition = array();

    if (isset($params['order_id']) && fn_string_not_empty($params['order_id'])) {
        $params['order_id'] = trim($params['order_id']);
        $condition[] = db_quote("h.order_id = ?i", $params['order_id']);
    }

    if (!empty($params['status_old'])) {
        $condition[] = db_quote("h.status = ?s", $params['status_old']);
    }

    if (!empty($params['status_new'])) {
        $condition[] = db_quote("h.status = ?s", $params['status_new']);
    }

    if (!empty($params['user_id'])) {
        $condition[] = db_quote("h.user_id = ?s", $params['user_id']);
    }


    $fields_str = implode(', ', $fields);
    $joins_str = ' ' . implode(' ', $joins);
    $condition_str = $condition ? (' WHERE ' . implode(' AND ', $condition)) : '';
    $sorting_str = db_sort($params, $sortings, 'date', 'desc');

    $limit = '';
    if (!empty($params['items_per_page'])) {
        $params['total_items'] = db_get_field(
            "SELECT COUNT(h.history_id) FROM ?:history_order_changes_status h" . $joins_str . $condition_str
        );
        $limit = db_paginate($params['page'], $params['items_per_page'], $params['total_items']);
    }

    $items = db_get_array(
        "SELECT " . $fields_str
        . " FROM ?:history_order_changes_status h"
        . $joins_str
        . $condition_str
        . $sorting_str
        . $limit
    );

    LastView::instance()->processResults('history_order_changes_status', $items, $params);

    return [$items, $params];
}

function fn_history_order_changes_status_change_order_status($status_to, $status_from, $order_info, $force_notification, $order_statuses, $place_order)
{
    if ($status_to != $status_from) {
        $user_id = 0;
        $user_id = $_SESSION['auth']['user_id'];
        fn_save_history_order_changes_status($order_info['order_id'], $user_id, $status_from, $status_to);
    }
}

function fn_history_order_changes_status_get_responsibles()
{
    $items = db_get_hash_single_array(
        "SELECT user_id, CONCAT(lastname, ' ', firstname) as name FROM ?:users WHERE user_type = ?s ",
        array('user_id', 'name'), 'A'
    );

    return $items;
}
