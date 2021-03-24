view: order_items {
  sql_table_name: demo_db.order_items ;;
  drill_fields: [id]

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
  }

  dimension: inventory_item_id {
    type: number
    # hidden: yes
    sql: ${TABLE}.inventory_item_id ;;
  }

  filter: my_filter {
    default_value: "my^_value"
  }

  parameter: date_selector {
    type: date_time
    description: "Use this field to select a date to filter results by."
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

  parameter: number_of_results {
    type: string
    allowed_value: {
      label: "Less than 500"
      value: "< 500"
    }
    allowed_value: {
      label: "Less than 10,000"
      value: "< 10000"
    }
    allowed_value: {
      label: "All Results"
      value: "> 0"
    }
  }

  dimension: profit {
    type: number
    sql: ${sale_price} - ${inventory_items.cost} ;;
  }
  dimension: cost {
    type: number
    sql: ${inventory_items.cost};;
  }

  dimension: order_id {
    type: number
    # hidden: yes
    sql: ${TABLE}.order_id ;;
  }

  dimension_group: returned {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.returned_at ;;
  }

  dimension: sale_price {
    type: number
    sql: ${TABLE}.sale_price ;;
  }
  measure: dynamic_sum {
    type: sum
    sql: ${TABLE}.{% parameter item_to_add_up %} ;;
    value_format_name: "usd"
    label_from_parameter: item_to_add_up
  }

  measure: count {
    type: count
    drill_fields: [id, inventory_items.id, orders.id]
  }
}
