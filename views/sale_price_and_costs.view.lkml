view: sale_price_and_costs {
  derived_table: {
    sql: SELECT
        order_items.sale_price  AS `sale_price`,
        inventory_items.cost  AS `cost`,
        users.city  AS `city`
      FROM demo_db.order_items  AS order_items
      LEFT JOIN demo_db.inventory_items  AS inventory_items ON order_items.inventory_item_id = inventory_items.id
      LEFT JOIN demo_db.orders  AS orders ON order_items.order_id = orders.id
      LEFT JOIN demo_db.users  AS users ON orders.user_id = users.id

      GROUP BY 1,2,3
      ORDER BY order_items.sale_price
 ;;
  }

  parameter: item_to_add_up {
    type: unquoted
    allowed_value: {
      label: "Total Sale Price"
      value: "sale_price"
    }
    allowed_value: {
      label: "Total Cost"
      value: "cost"
    }
    allowed_value: {
      label: "Total Profit"
      value: "profit"
    }
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  dimension: sale_price {
    type: number
    sql: ${TABLE}.sale_price ;;
  }

  dimension: cost {
    type: number
    sql: ${TABLE}.cost ;;
  }

  dimension: profit {
    type: number
    sql: ${TABLE}.profit ;;
  }


  dimension: city {
    type: string
    sql: ${TABLE}.city ;;
  }

  measure: dynamic_sum {
    type: sum
    sql: ${TABLE}.{% parameter item_to_add_up %} ;;
    value_format_name: "usd"
    label_from_parameter: item_to_add_up
  }

  set: detail {
    fields: [sale_price, cost, city]
  }
}
