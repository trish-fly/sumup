### Model: Network

{% docs model_network %}
This model provides data from a network provider.
{% enddocs %}

### Active Add-on ID
{% docs dim_active_addon_id %}
A unique ID associated with an active add-on or plan.
{% enddocs %}

### Active Add-on Name ID
{% docs dim_active_addon_name %}
The name of the data/call plan in use.
{% enddocs %}

### Call Type ID
{% docs dim_call_type %}
Type of usage (e.g., Data for internet usage).
{% enddocs %}

### Billable Duration
{% docs dim_billable_duration %}
The duration in milliseconds for which the provider is being billed..
{% enddocs %}

### CDR ID
{% docs dim_cdr_id %}
A unique identifier for this Call Detail Record (CDR).
{% enddocs %}

### Call Date Time
{% docs dim_call_date_time %}
Timestamp of the event in milliseconds (epoch time).
{% enddocs %}

### Country
{% docs dim_country %}
The country where the usage occurred.
{% enddocs %}

### ICC ID
{% docs dim_icc_id %}
The SIM card identifier.
{% enddocs %}

### IMSI
{% docs dim_imsi %}
The International Mobile Subscriber Identity (IMSI), which identifies the subscriber.
{% enddocs %}

### MSISDN
{% docs dim_msisdn %}
The phone number (MSISDN).
{% enddocs %}

### Operator
{% docs dim_operator %}
The mobile operator providing the service (e.g., AT&T WIRELESS, VODAFONE OMNITEL).
{% enddocs %}

### Traffic type
{% docs dim_traffic_type %}
Likely represents the type of network traffic (e.g., MO = Mobile Originated).
{% enddocs %}

### Zone ID
{% docs dim_zone_id %}
Possibly a classification of the usage region or pricing zone.
{% enddocs %}

### Actual Usage
{% docs dim_actual_usage %}
The actual amount of data used (in GB or MB).
{% enddocs %}

### Usage Category
{% docs dim_usage_category %}
Category of usage, possible value are: high, medium, low
{% enddocs %}