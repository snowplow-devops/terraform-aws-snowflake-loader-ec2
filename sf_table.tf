resource "snowflake_table" "events" {
  database = snowflake_database.loader.name
  schema   = snowflake_schema.atomic.name
  name     = "EVENTS"

  column {
    name     = "app_id"
    type     = "VARCHAR(255)"
    nullable = true
  }

  column {
    name     = "platform"
    type     = "VARCHAR(255)"
    nullable = true
  }

  column {
    name     = "etl_tstamp"
    type     = "TIMESTAMP_NTZ(9)"
    nullable = true
  }

  column {
    name     = "collector_tstamp"
    type     = "TIMESTAMP_NTZ(9)"
    nullable = false
  }

  column {
    name     = "dvce_created_tstamp"
    type     = "TIMESTAMP_NTZ(9)"
    nullable = true
  }

  column {
    name     = "event"
    type     = "VARCHAR(128)"
    nullable = true
  }

  column {
    name     = "event_id"
    type     = "VARCHAR(36)"
    nullable = false
  }

  column {
    name     = "txn_id"
    type     = "NUMBER(38,0)"
    nullable = true
  }

  column {
    name     = "name_tracker"
    type     = "VARCHAR(128)"
    nullable = true
  }

  column {
    name     = "v_tracker"
    type     = "VARCHAR(100)"
    nullable = true
  }

  column {
    name     = "v_collector"
    type     = "VARCHAR(100)"
    nullable = false
  }

  column {
    name     = "v_etl"
    type     = "VARCHAR(100)"
    nullable = false
  }

  column {
    name     = "user_id"
    type     = "VARCHAR(255)"
    nullable = true
  }

  column {
    name     = "user_ipaddress"
    type     = "VARCHAR(128)"
    nullable = true
  }

  column {
    name     = "user_fingerprint"
    type     = "VARCHAR(128)"
    nullable = true
  }

  column {
    name     = "domain_userid"
    type     = "VARCHAR(128)"
    nullable = true
  }

  column {
    name     = "domain_sessionidx"
    type     = "NUMBER(38,0)"
    nullable = true
  }

  column {
    name     = "network_userid"
    type     = "VARCHAR(128)"
    nullable = true
  }

  column {
    name     = "geo_country"
    type     = "VARCHAR(2)"
    nullable = true
  }

  column {
    name     = "geo_region"
    type     = "VARCHAR(3)"
    nullable = true
  }

  column {
    name     = "geo_city"
    type     = "VARCHAR(75)"
    nullable = true
  }

  column {
    name     = "geo_zipcode"
    type     = "VARCHAR(15)"
    nullable = true
  }

  column {
    name     = "geo_latitude"
    type     = "FLOAT"
    nullable = true
  }

  column {
    name     = "geo_longitude"
    type     = "FLOAT"
    nullable = true
  }

  column {
    name     = "geo_region_name"
    type     = "VARCHAR(100)"
    nullable = true
  }

  column {
    name     = "ip_isp"
    type     = "VARCHAR(100)"
    nullable = true
  }

  column {
    name     = "ip_organization"
    type     = "VARCHAR(128)"
    nullable = true
  }

  column {
    name     = "ip_domain"
    type     = "VARCHAR(128)"
    nullable = true
  }

  column {
    name     = "ip_netspeed"
    type     = "VARCHAR(100)"
    nullable = true
  }

  column {
    name     = "page_url"
    type     = "VARCHAR(4096)"
    nullable = true
  }

  column {
    name     = "page_title"
    type     = "VARCHAR(2000)"
    nullable = true
  }

  column {
    name     = "page_referrer"
    type     = "VARCHAR(4096)"
    nullable = true
  }

  column {
    name     = "page_urlscheme"
    type     = "VARCHAR(16)"
    nullable = true
  }

  column {
    name     = "page_urlhost"
    type     = "VARCHAR(255)"
    nullable = true
  }

  column {
    name     = "page_urlport"
    type     = "NUMBER(38,0)"
    nullable = true
  }

  column {
    name     = "page_urlpath"
    type     = "VARCHAR(3000)"
    nullable = true
  }

  column {
    name     = "page_urlquery"
    type     = "VARCHAR(6000)"
    nullable = true
  }

  column {
    name     = "page_urlfragment"
    type     = "VARCHAR(3000)"
    nullable = true
  }

  column {
    name     = "refr_urlscheme"
    type     = "VARCHAR(16)"
    nullable = true
  }

  column {
    name     = "refr_urlhost"
    type     = "VARCHAR(255)"
    nullable = true
  }

  column {
    name     = "refr_urlport"
    type     = "NUMBER(38,0)"
    nullable = true
  }

  column {
    name     = "refr_urlpath"
    type     = "VARCHAR(6000)"
    nullable = true
  }

  column {
    name     = "refr_urlquery"
    type     = "VARCHAR(6000)"
    nullable = true
  }

  column {
    name     = "refr_urlfragment"
    type     = "VARCHAR(3000)"
    nullable = true
  }

  column {
    name     = "refr_medium"
    type     = "VARCHAR(25)"
    nullable = true
  }

  column {
    name     = "refr_source"
    type     = "VARCHAR(50)"
    nullable = true
  }

  column {
    name     = "refr_term"
    type     = "VARCHAR(255)"
    nullable = true
  }

  column {
    name     = "mkt_medium"
    type     = "VARCHAR(255)"
    nullable = true
  }

  column {
    name     = "mkt_source"
    type     = "VARCHAR(255)"
    nullable = true
  }

  column {
    name     = "mkt_term"
    type     = "VARCHAR(255)"
    nullable = true
  }

  column {
    name     = "mkt_content"
    type     = "VARCHAR(500)"
    nullable = true
  }

  column {
    name     = "mkt_campaign"
    type     = "VARCHAR(255)"
    nullable = true
  }

  column {
    name     = "se_category"
    type     = "VARCHAR(1000)"
    nullable = true
  }

  column {
    name     = "se_action"
    type     = "VARCHAR(1000)"
    nullable = true
  }

  column {
    name     = "se_label"
    type     = "VARCHAR(4096)"
    nullable = true
  }

  column {
    name     = "se_property"
    type     = "VARCHAR(1000)"
    nullable = true
  }

  column {
    name     = "se_value"
    type     = "FLOAT"
    nullable = true
  }

  column {
    name     = "tr_orderid"
    type     = "VARCHAR(255)"
    nullable = true
  }

  column {
    name     = "tr_affiliation"
    type     = "VARCHAR(255)"
    nullable = true
  }

  column {
    name     = "tr_total"
    type     = "NUMBER(18,2)"
    nullable = true
  }

  column {
    name     = "tr_tax"
    type     = "NUMBER(18,2)"
    nullable = true
  }

  column {
    name     = "tr_shipping"
    type     = "NUMBER(18,2)"
    nullable = true
  }

  column {
    name     = "tr_city"
    type     = "VARCHAR(255)"
    nullable = true
  }

  column {
    name     = "tr_state"
    type     = "VARCHAR(255)"
    nullable = true
  }

  column {
    name     = "tr_country"
    type     = "VARCHAR(255)"
    nullable = true
  }

  column {
    name     = "ti_orderid"
    type     = "VARCHAR(255)"
    nullable = true
  }

  column {
    name     = "ti_sku"
    type     = "VARCHAR(255)"
    nullable = true
  }

  column {
    name     = "ti_name"
    type     = "VARCHAR(255)"
    nullable = true
  }

  column {
    name     = "ti_category"
    type     = "VARCHAR(255)"
    nullable = true
  }

  column {
    name     = "ti_price"
    type     = "NUMBER(18,2)"
    nullable = true
  }

  column {
    name     = "ti_quantity"
    type     = "NUMBER(38,0)"
    nullable = true
  }

  column {
    name     = "pp_xoffset_min"
    type     = "NUMBER(38,0)"
    nullable = true
  }

  column {
    name     = "pp_xoffset_max"
    type     = "NUMBER(38,0)"
    nullable = true
  }

  column {
    name     = "pp_yoffset_min"
    type     = "NUMBER(38,0)"
    nullable = true
  }

  column {
    name     = "pp_yoffset_max"
    type     = "NUMBER(38,0)"
    nullable = true
  }

  column {
    name     = "useragent"
    type     = "VARCHAR(1000)"
    nullable = true
  }

  column {
    name     = "br_name"
    type     = "VARCHAR(50)"
    nullable = true
  }

  column {
    name     = "br_family"
    type     = "VARCHAR(50)"
    nullable = true
  }

  column {
    name     = "br_version"
    type     = "VARCHAR(50)"
    nullable = true
  }

  column {
    name     = "br_type"
    type     = "VARCHAR(50)"
    nullable = true
  }

  column {
    name     = "br_renderengine"
    type     = "VARCHAR(50)"
    nullable = true
  }

  column {
    name     = "br_lang"
    type     = "VARCHAR(255)"
    nullable = true
  }

  column {
    name     = "br_features_pdf"
    type     = "BOOLEAN"
    nullable = true
  }

  column {
    name     = "br_features_flash"
    type     = "BOOLEAN"
    nullable = true
  }

  column {
    name     = "br_features_java"
    type     = "BOOLEAN"
    nullable = true
  }

  column {
    name     = "br_features_director"
    type     = "BOOLEAN"
    nullable = true
  }

  column {
    name     = "br_features_quicktime"
    type     = "BOOLEAN"
    nullable = true
  }

  column {
    name     = "br_features_realplayer"
    type     = "BOOLEAN"
    nullable = true
  }

  column {
    name     = "br_features_windowsmedia"
    type     = "BOOLEAN"
    nullable = true
  }

  column {
    name     = "br_features_gears"
    type     = "BOOLEAN"
    nullable = true
  }

  column {
    name     = "br_features_silverlight"
    type     = "BOOLEAN"
    nullable = true
  }

  column {
    name     = "br_cookies"
    type     = "BOOLEAN"
    nullable = true
  }

  column {
    name     = "br_colordepth"
    type     = "VARCHAR(12)"
    nullable = true
  }

  column {
    name     = "br_viewwidth"
    type     = "NUMBER(38,0)"
    nullable = true
  }

  column {
    name     = "br_viewheight"
    type     = "NUMBER(38,0)"
    nullable = true
  }

  column {
    name     = "os_name"
    type     = "VARCHAR(50)"
    nullable = true
  }

  column {
    name     = "os_family"
    type     = "VARCHAR(50)"
    nullable = true
  }

  column {
    name     = "os_manufacturer"
    type     = "VARCHAR(50)"
    nullable = true
  }

  column {
    name     = "os_timezone"
    type     = "VARCHAR(255)"
    nullable = true
  }

  column {
    name     = "dvce_type"
    type     = "VARCHAR(50)"
    nullable = true
  }

  column {
    name     = "dvce_ismobile"
    type     = "BOOLEAN"
    nullable = true
  }

  column {
    name     = "dvce_screenwidth"
    type     = "NUMBER(38,0)"
    nullable = true
  }

  column {
    name     = "dvce_screenheight"
    type     = "NUMBER(38,0)"
    nullable = true
  }

  column {
    name     = "doc_charset"
    type     = "VARCHAR(128)"
    nullable = true
  }

  column {
    name     = "doc_width"
    type     = "NUMBER(38,0)"
    nullable = true
  }

  column {
    name     = "doc_height"
    type     = "NUMBER(38,0)"
    nullable = true
  }

  column {
    name     = "tr_currency"
    type     = "VARCHAR(3)"
    nullable = true
  }

  column {
    name     = "tr_total_base"
    type     = "NUMBER(18,2)"
    nullable = true
  }

  column {
    name     = "tr_tax_base"
    type     = "NUMBER(18,2)"
    nullable = true
  }

  column {
    name     = "tr_shipping_base"
    type     = "NUMBER(18,2)"
    nullable = true
  }

  column {
    name     = "ti_currency"
    type     = "VARCHAR(3)"
    nullable = true
  }

  column {
    name     = "ti_price_base"
    type     = "NUMBER(18,2)"
    nullable = true
  }

  column {
    name     = "base_currency"
    type     = "VARCHAR(3)"
    nullable = true
  }

  column {
    name     = "geo_timezone"
    type     = "VARCHAR(64)"
    nullable = true
  }

  column {
    name     = "mkt_clickid"
    type     = "VARCHAR(128)"
    nullable = true
  }

  column {
    name     = "mkt_network"
    type     = "VARCHAR(64)"
    nullable = true
  }

  column {
    name     = "etl_tags"
    type     = "VARCHAR(500)"
    nullable = true
  }

  column {
    name     = "dvce_sent_tstamp"
    type     = "TIMESTAMP_NTZ(9)"
    nullable = true
  }

  column {
    name     = "refr_domain_userid"
    type     = "VARCHAR(128)"
    nullable = true
  }

  column {
    name     = "refr_dvce_tstamp"
    type     = "TIMESTAMP_NTZ(9)"
    nullable = true
  }

  column {
    name     = "domain_sessionid"
    type     = "VARCHAR(128)"
    nullable = true
  }

  column {
    name     = "derived_tstamp"
    type     = "TIMESTAMP_NTZ(9)"
    nullable = true
  }

  column {
    name     = "event_vendor"
    type     = "VARCHAR(1000)"
    nullable = true
  }

  column {
    name     = "event_name"
    type     = "VARCHAR(1000)"
    nullable = true
  }

  column {
    name     = "event_format"
    type     = "VARCHAR(128)"
    nullable = true
  }

  column {
    name     = "event_version"
    type     = "VARCHAR(128)"
    nullable = true
  }

  column {
    name     = "event_fingerprint"
    type     = "VARCHAR(128)"
    nullable = true
  }

  column {
    name     = "true_tstamp"
    type     = "TIMESTAMP_NTZ(9)"
    nullable = true
  }

  primary_key {
    name = "event_id_pk"
    keys = ["event_id"]
  }
}
