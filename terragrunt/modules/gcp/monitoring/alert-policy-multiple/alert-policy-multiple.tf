module "alert_policies" {
  for_each              = var.alert_policies
  source                = "./alert-policy"
  name                  = each.key
  combiner              = each.value.combiner
  notification_channels = each.value.notification_channels
  conditions            = each.value.conditions
  documentation         = each.value.documentation
  user_labels           = var.user_labels
  metric_name           = can(each.value.metric_name) ? each.value.metric_name : null
  metric_filter         = can(each.value.metric_filter) ? each.value.metric_filter : null

}
