i will give you the api docs for ezviz make a fully functional fully tested api helper for ezviz api in dart

1 API Definitions

1.1 Request Data

POST:
Request Header: content-type: application/x-www-form-urlencoded.
1.2 Request Return

Return Data: If the returned HTTP status code is 200, return json data. Otherwise, it means request error. Get the error details according to the API error code.
1.3 Public Return Code

Return Code	Return Information	Description
200	Operating succeeded	Request succeeded
10007	Call times reached the limit	
10029	Call frequency reached the limit	API call frequency reached the limit
1.4 Parameter Remarks

accessToken is the token for login. Please get it via background and ensure its confidentiality.


、API List

This section contains the API used for the admin user to get the accessToken via appKey and secret.

See the following list:

No.	Function	Description
1	Get accessToken via appKey and secret	Used for the administrator to get the accessToken
1.1 Get accessToken via appKey and secret

API Function

This API is used for the admin user to get the accessToken。

Request Address

https://open.ezvizlife.com/api/lapp/token/get

Request Type

POST

Request Parameters

Parameter Name	Type	Description	Required
appKey	String	appKey	Y
appSecret	String	appSecret	Y
HTTP Request Message
POST /api/lapp/token/get HTTP/1.1
Host: open.ezvizlife.com
Content-Type: application/x-www-form-urlencoded
appKey=9mqitppidgce4y8n54ranvyqc9fjtsrl&appSecret=096e76501644989b63ba0016ec5776
Return Data
{
    "data": {
        "accessToken": "at.7jrcjmna8qnqg8d3dgnzs87m4v2dme3l-32enpqgusd-1jvdfe4-uxo15ik0s",
        "expireTime": 1470810222045,
        "areaDomain": "https://iusopen.ezvizlife.com"
    },
    "code": "200",
    "msg": "Operating succeeded!"
}
Return Field
Field Name	Type	Description
accessToken	String	Obtained accessToken
expireTime	long	Accurate to millisecond
areaDomain	String	the open api domain name of the user's region, the accessToken is valid only in this region
Return Code
Return Code	Return Information	Description
200	Operating succeeded.	Request succeeded.
10001	The parameter is empty or incorrect format.	The parameter is empty or incorrect format.
10005	appKey exception	appKey is frozen.
10017	appKey does not exist.	Check the correctness of appKey
10030	appkey and appSecret mismatched.	
49999	Data exception.	API call exception.



This section includes related interfaces of play address.

The interfaces are listed as follows:

Serial No	Interface Function	Description
1	Obtain play address	Obtain play address of the device
2	Invalidate play address	Invalidate play address of the device
1.1Obtain Play Address

Function

This interface is used to obtain play address of the single device through device serial number and channel number.

Request Address

{areaDomain}/api/lapp/live/address/get

Request Method

POST

Request Parameters

Parameters	Type	Description	Required
accessToken	String	Access token obtained in authorization process	Y
deviceSerial	String	The serial Number of the device, e.g. 427734222, all in English notation, limited to a maximum of 50 characters.	Y
channelNo	Integer	Channel number, not required, the default is 1	N
protocol	Integer	Stream protocol, 1-ezopen, 2-hls, 3-rtmp, 4-flv, the default is 1	N
code	String	Video encryption password of device in the ezopen protocol address	N
expireTime	Integer	Expiration rime, the unit is second; set validity period for hls/rtmp/flv: 30s-720d	N
type	String	Address type, 1-preview, 2- local recording playback, 3-CloudPlay recording playback, not required, the default is 1	N
quality	Integer	Video quality, 1-HD (main bitrate), 2-Fluent (sub-bitrate), the default is 1.	N
startTime	String	The playback start time of the local recording or CloudPlay recording, e.g. 2019-12-01 00:00:00When type != 1 and Protocol != 1: (1) startTime and stopTime are empty, the stopTime is the current time and the startTime is the previous day of the current time; (2) the stopTime is empty and the startTime is not empty, the stopTime is the day after the startTime; (3) the startTime is empty and the stopTime is not empty, the startTime is the previous day of the stopTime.	N
stopTime	String	The playback stop time of the local recordings or CloudPlay recordings, e.g. 2019-12-01 00:00:00	N
HTTP Request Post

POST /api/lapp/live/address/get HTTP/1.1
Host: iusopen.ezvizlife.com
Content-Type: application/x-www-form-urlencoded
Content-Length: 110

accessToken=at.bju93z4w2iifhu1zbxl7phrz8852juxg-99skn9j3kf-05iffrm-ugesv5l9h&deviceSerial=F00497273&protocol=2

Return Data
{
    "msg": "Operation succeeded",
    "code": "200",
    "data": {
        "id": "512628410958159872",
        "url": "https://iusopen.ezvizlife.com/v3/openlive/F00497273_1_1.m3u8?expire=1668578537&id=512628410958159872&t=56528d84c512aad8b4cfdabb43323e2ce692de022cdd9b0dce595a7d8677bd61&ev=100",
        "expireTime": "2022-11-16 06:02:17"
    }
}

Return Field：
Filed Name	Type	Description
code	String	Status code, refers to the return code below. The error code is preferred to be judged, return 200 indicates success
msg	String	Status description
id	String	Live address ID
url	String	Live address
expireTime	String	Expiration time
Return Code：
Return Code	Return Message	Note
200	Operation successfully, the live address within validity period is obtained	Request successfully
1.2Invalidate Play Address

Function

This interface is used to invalidate the obtained playing address

Request Address

`{areaDomain}/api/lapp/live/address/disable

Request Method

POST

Request Parameters

Parameters	Type	Description	Required
accessToken	String	Access token obtained in authorization process	Y
deviceSerial	String	The serial Number of the device, e.g. 427734222, all in English notation, limited to a maximum of 50 characters.	Y
channelNo	Integer	Channel number, not required, the default is 1	N
urlId	String	Live address ID	N
HTTP Request Report

POST /api/lapp/live/address/disable HTTP/1.1
Host: iusopen.ezvizlife.com
Content-Type: application/x-www-form-urlencoded
Content-Length: 136

accessToken=at.bju93z4w2iifhu1zbxl7phrz8852juxg-99skn9j3kf-05iffrm-ugesv5l9h&deviceSerial=F00497273&channelNo=1&urlId=512638098828922880



Return Data
{
    "msg": "Operation succeeded",
    "code": "200"
}


Return Code：
Return Code	Return Message	Note
200	Operation successfully, the live address within validity period is obtained	Request successfully


uery local video record（GET）

query local video record

URL

{areaDomain}/api/v3/das/device/local/video/query

Request

Header

Parameter	Type	Required	Description	Example
accessToken	string	Y	accessToken	 
deviceSerial	string	Y	device serial	 
channelNo	string	N	channel number	 
query

Parameter	Type	Required	Description	Example
recordType	int	N	record type 1 timing record 2 event record 3 intelligent-car 4 intelligent-human The default value is all types	 
startTime	string	N	Start time, format is 2022-08-22 13:59:13, optional, the default value is 0 o'clock on the day	 
endTime	string	N	End time, format i is 2022-08-22 13:59:13, optional, the default value is the current time	 
Response

return parameter

Parameter	Type	Description	Example
startTime	string	Start time	 
endTime	string	End time	 
deviceSerial	string	Device serial	 
cameraNo	string	Channel number	 
type	string	Record type	 
size	string	Record size	 
return data

{
	"meta": {
		"code": 200,
		"message": "操作成功",
		"moreInfo": null
	},
	"data": [
		{
			"startTime": "2022-11-10T11:44:15",
			"endTime": "2022-11-10T11:51:21",
			"deviceSerial": "J67757598",
			"cameraNo": "1",
			"type": "TIMING",
			"size": ""
		}
	]
}
Error code

Return Code	Error code	Description	Solution
200	200	Operation succeeded	 
200	2003	Device offline	 
200	2007	Wrong device number	 
200	2009	The device response times out	 
200	2030	Device not support	 
401	10002	accessToken exception or expired.	 
200	20015	Device not support this function	 



Device capability set description

The device capability set is a set of features used to characterize the capabilities of the device. Based on the device capability set, you can clearly know which functions the device supports.

Due to the continuous update of the ability assembly, if you find a field that does not exist in this description, please promptly feedback open-team@ezvizlife.com

The user can obtain the device capability set by calling the [Query Device Capability Set] (#api_capacity) interface

Serial Number	Field	Capability Set Field Description
1	support_defence	Whether to support arming and disarming, activity detection switch
2	support_talk	Whether to support intercom: 0-not supported, 1-full duplex, 3-half duplex
3	support_defenceplan	Whether to support arming and disarming plan 0-not supported, 1-supported, 2-supported new device plan agreement
4	support_disk	Whether to support storage format 0-not supported, 1-supported
5	support_privacy	Whether to support privacy protection 0-not supported, 1-supported
6	support_message	Whether to support the message 0-not supported, 1-supported
7	support_alarm_voice	Whether to support alarm sound configuration 0-not supported, 1-supported
8	support_auto_offline	Whether to support the device to automatically go online and offline 0-not supported, 1-supported
9	supprot_encrypt	Whether to support video image encryption 0-not supported, 1-supported
10	support_upgrade	Whether to support device upgrade 0-not supported, 1-supported
11	support_cloud	Whether the device model supports cloud storage 0-not supported, 1-supported
12	support_cloud_version	Whether the device version supports cloud storage 0-not supported, 1-support needs to be combined with support_cloud: support_cloud = 1, support_cloud_version = 1 only supports cloud storage support_cloud = 1, support_cloud_version = 0, this type of device supports cloud storage, but the current firmware version does not support cloud storage. Support_cloud = 0 This type of device does not support cloud storage.
13	support_wifi	Whether to support WI-FI: 0-not supported, 1-support netsdk configuration WI-FI, 2-support new WI-FI configuration with userId, 3-support one Key configuration WI-FI
14	support_capture	Whether to support cover capture: 0-not supported, 1-supported
15	support_modify_pwd	Whether to support changing device encryption password: 0-not supported, 1-supported
16	support_resolution	Video playback ratio 16-9 means 16: 9 resolution, default 16-9
17	support_multi_screen	Whether to support multi-screen playback 0-not supported, 1-supported (use by client, regardless of device)
18	support_upload_cloud_file	Whether to support mobile phone camera upload to cloud storage `0-not supported, 1-supported
19	support_add_del_detector	Whether to support app to remotely add and remove peripherals (detectors): 0-not supported, 1-supported
20	support_ipc_link	Whether to support IPC and A1 linkage relationship settings: 0-not supported, 1-supported
21	support_modify_detectorname	Whether to support modifying peripheral (detector) name: 0-not supported, 1`-supported
22	support_safe_mode_plan	Whether to support switching safety function mode regularly: 0-not supported, 1-supported
23	support_modify_detectorguard	Does the A1 device support separate arming and disarming:
This field does not exist: Not supported
This field exists: each peripheral is separated by a comma, as listed in table order, each value is 32 bits The value indicates whether each mode can be set in each mode, if a certain detector can be set to enable this parameter, the position is 1,for example "support_modify_guard": "0,0,7,7, 7,0,7,0,0,0 "is the following ability description
detector type	outgoing mode (bit0)	Sleep mode (bit1)	Home mode (bit2)
Smoke feeling	0	0	0
emergency button	0	0	0
Door magnet	1	1	1
Infrared	1	1	1
Curtain	1	1	1
Emergency button	0	0	0
Single door magnet	1	1	1
Sirens	0	0	0
Gas detector	0	0	0
Flood detector	0	0	0
24	support_weixin	Whether the detector type supports WeChat interconnection: 0-not supported, 1-supported
25	support_ssl	Whether to support sound source localization: 0-not supported, 1-supported
26	support_related_device	Whether to support the associated device 0-no associated device, 1-associated monitoring point or N1, 2-associated detector or A1, 3-associated monitoring point detector or R1, 4associated multi-channel device
27	support_related_storage	Does NVR / R1 support related IPC storage: 0-not supported, 1-supported
28	support_remote_auth_randcode	Whether to support device remote authorization to obtain password, 0-not supported, 1-supported
29	support_sdk_transport	Whether to support the ability level of device cross-network configuration: 0-not supported, 1-supported
30	ptz_top_bottom	Whether to support PTZ up and down rotation 0-not supported, 1-supported
31	ptz_left_right	Whether to support pan / tilt rotation 0-not supported, 1-supported
32	ptz_45	Whether to support pan / tilt rotation at 45 degrees 0-not supported, 1-supported
33	ptz_zoom	Whether to support PTZ zoom control 0-not supported, 1-supported
34	support_ptz	Whether to support PTZ control 0-not supported, 1-supported, Note: The capability set of the new device is split into four capabilities of 30-33
35	ptz_preset	Whether to support PTZ preset point 0-not supported, 1-supported
36	ptz_common_cruise	Whether to support normal cruise 0-not supported, 1-supported
37	ptz_figure_cruise	Whether to support pattern cruise 0-not supported, 1-supported
38	ptz_center_mirror	Whether to support center mirroring 0-not supported, 1-supported
39	ptz_left_right_mirror	Whether to support left and right mirroring 0-not supported, 1-supported
40	ptz_top_bottom_mirror	Whether to support up and down mirroring 0-not supported, 1-supported
41	ptz_close_scene	Whether to support close lens 0-not supported, 1-supported
42	support_wifi_2.4G	Whether to support 2.4G wireless frequency band 0-not supported, 1-supported
43	support_wifi_5G	Whether to support 5G wireless frequency band 0-not supported, 1-supported
44	support_wifi_portal	Whether to support marketing wifi, only take effect when support_wifi_2.4G = 1: 1-support but cannot set marketing page (X1), 2-support and can set marketing page,0-Not supported
45	support_unbind	Whether to support the user to unbind the device 0-not supported, 1-support reset button to unbind, 2-support interface click OK button to unbind
46	support_auto_adjust	Whether to support adaptive stream 0-not supported, 1-supported
47	support_timezone	Whether to support time zone configuration 0-not supported, 1-supported
48	support_language	Supported language types: ENGLISH, SIMPCN, ....
49	support_close_infrared_light	Whether to support infrared switch 0-not supported, 1-supported
50	support_modify_chan_name	Whether to support channel name configuration to the device (IPC / NVR) 0-not supported, 1-supported
51	support_ptz_model	0-support direct connection + forward PTZ control, 1-support direct connection PTZ control, 2-support forward PTZ control
52	support_talk_type	0-use the microphone above, 1-use the microphone below for intercom
53	support_chan_type	Channel type, 1-digital channel, 2-analog channel
54	support_flow_statistics	Whether to support passenger flow statistics 0-not supported, 1-supported
55	support_more	Whether to support the device setting function 0-not supported, 1-supported Note: "More configuration" is added on the device settings page, this item is implemented according to [device capability level], and more configurations enter H5 Web display
56	support_remote_quiet	Does A1 support remote alarm (silent) function 0-not supported, 1-supported
57	support_customize_rate	Whether to support custom bit rate 0-not supported, 1-supported
58	support_rectify_image	Whether to support deformity correction 0-not supported, 1-supported
59	support_bluetooth	Whether to support Bluetooth 0-not supported, 1-supported
60	support_p2p_mode	The default is 0, which means the old p2p protocol; configuration is 1, which means that this version supports the new p2p protocol
61	support_microscope	Whether to support the microscope function 0-not supported, 1-supported
62	support_sensibility_adjust	Whether to support motion detection sensitivity adjustment 0-not supported, 1-supported
63	support_sleep	Whether to support sleep function 0-not supported, 1-supported
64	support_audio_onoff	Whether to support audio switch setting 0-not supported, 1-supported
65	support_protection_mode	0: No protection mode, there may be activity detection (based on support_denfence (serial number 1)) 1: Only protection mode 2: There is protection mode, there may be activity detection (based on support_denfence (serial number 1)) Example of capability level configuration: support_protection_modesupport_denfenceA111 ordinary IPC01C1S21
66	support_rate_limit	Whether to support HD bit rate limit 0-does not support bit rate limit, 1-supports HD bit rate limit
67	support_userId	Is it supported to associate device via UserID 0-not supported, 1-supported
68	support_music	Whether to support the children's song playback function 0-not supported, 1-supported
69	support_replay_speed	Whether to support the function of adjusting playback speed 0-not supported, 1-supported (only supported by IPC)
70	support_reverse_direct	Whether to support reverse direct connection function 0-not supported, 1-supported
71	support_channel_offline_notify	Whether to support channel offline notification, after support, channel offline will trigger ideoloss alarm 0-not supported, 1-supported
72	support_fullscreen_ptz	Whether to support the panoramic pan / tilt function 0-not supported, 1-supported (supported by C6B and other pan / tilt cameras). If the capability set support_fullscreen_ptz_12 (serial number 82) exists, please refer to the capability set support_fullscreen_ptz_12
73	support_preset_alarm	Whether to support preset alarm linkage 0-not supported, 1-supported (supported by C6B and other PTZ cameras)
74	support_intelligent_track	Whether to support intelligent tracking 0-not supported, 1-supported (C6B and other PTZ camera support)
75	support_key_focus	Whether to support one-key focus 0-not supported, 1-supported (supported by F1, F2 and other zoom cameras)
76	support_volumn_set	Whether to support volume adjustment 0-not supported, 1-supported
77	support_temperature_alarm	Whether to support temperature and humidity alarm 0-not supported, 1-supported (F2, C1S and other cameras with temperature and humidity sensor support)
78	support_mcvolumn_set	Whether to support microphone volume adjustment: 0-not supported, 1-supported
79	support_unlock	Whether to support unlocking support 0-not supported, 1-supported
80	support_noencript_via_antproxy	Does it support the ability to automatically encrypt the "no video encryption" stream when going through the proxy 0-not supported, 1-supported
81	support_device_offline_notify	Whether to support device offline notification 0-not supported, 1-supported
82	support_fullscreen_ptz_12	Whether to support the panoramic pan / tilt function 0-not supported, 1-supported (C6B and other pan / tilt camera support, 12 panoramic pan / tilt pictures)
83	support_speech_recognition	Whether to support speech recognition 0-not supported, 1-supported
84	support_message_cover	Whether to support message cover 0-not supported, 1-supported
85	support_nat_pass	Whether to support NAT combination with NAT combination of 3-4 (P2PV2.1) 0-not supported, 1-supported
86	support_nvr_whitelist	Whether NVR supports whitelist member management 0-not supported, 1-supported
87	support_voice_alarmclock	Whether to support voice alarm function 0-not supported, 1-supported
88	support_new_talk	Whether to support the new intercom service 0-not supported, 1-supported
89	support_fullday_record	Whether to support all-day recording configuration switch 0-not supported, 1-supported
90	support_query_play_connections	Whether to support querying current preview, playback link information 0-not supported, 1-supported
91	support_ptz_auto_reset	Whether to support PTZ auto reset 0-not supported, 1-supported
92	support_fisheye_mode	Whether to support fisheye mode 0-not supported, 1-supported
93	support_custom_voice	Whether to support custom voice 0-not supported, 1-supported (voice alarm clock, alarm sound use)
94	support_new_sound_wave	Whether to support sound wave configuration (high frequency version) 0-not supported, 1-supported
95	replay_chan_nums	Number of channels that can be associated with X3 or N1
96	support_horizontal_panoramic	Whether to support horizontal panorama 0-not supported, 1-supported
97	support_active_defense	Whether to support active defense function: 0-not supported, 1-active defense button, 2-active defense button + light reminder switch
98	support_motion_detect_area	Whether to support motion detection area drawing 0-not supported, 1-supported
99	support_chan_defence	Whether to support channel arming and disarming 0-not supported, 1-supported
100	ptz_focus	Whether to support focal length mode 0-not supported, 1-supported
101	support_pir_detect	Whether to support infrared detection capability 0-not supported, 1-supported (cat eye)
102	support_doorbell_talk	Whether to support the doorbell call ability 0-not supported, 1-supported (cat eye)
103	support_face_detect	Whether to support face detection capability 0-not supported, 1-supported (cat eye)
104	support_restart_time	Device restart time, the configuration unit is seconds, the default is 120s
105	support_human_filter	Whether to support human filtering capability 0-not supported, 1-supported) (C5SI model, the device is supported by smart chip hardware)
106	support_human_service	Whether to support humanoid detection capability 0-not supported, 1-supported (device + platform service is activated to realize humanoid detection service capability device can be supported by updating software version)
107	support_ap_mode	Whether to support adding device to configure WiFi use, 0: not supported, 1: smartconfig + sound wave failure, support AP configuration network, 2: device default AP configuration network
108	support_continuous_cloud	Whether to support continuous cloud storage 0-not supported, 1-supported, note: it has nothing to do with support_cloud (serial number 11)
109	support_doorbell_sound	Whether to support focal length mode 0-not supported, 1-supported
110	support_associate_detector	Whether to support association detector 0-not supported, 1-supported
111	support_modify_username	Whether to support the modification of the user's note name of the door lock 0-not supported, 1-supported
112	support_transfertype	Preview streaming format transfer type: 0-tcp, 1-udp, default 0 means tcp
113	support_vertical_panoramic	Whether to support vertical panorama (corresponding to support_horizontal_panoramic (serial number 96)) 0-not supported, 1-supported
114	support_alarm_light	Whether to support security lights 0-not supported, 1-supported
115	support_alarm_area	Whether to support security lights 0-not supported, 1-supported
116	support_chime	Whether to support doorbell extension 0-not supported, 1-supported
117	support_video_mode	Whether to support support_video_mode 0-not supported, 1-supported
118	support_relation_camera	Whether to support W2D related camera function 0-not supported, 1-supported
119	support_pir_setting	Whether to support PIR (infrared) area setting 0-not supported, 1-supported
120	support_battery_manage	Whether to support battery management 0-not supported, 1-supported





Push Message System (webhook)

1.Introduction

Webhook: a web custom callback entry that automatically calls the specified URL when some behavior is triggered by the program.

Compared with message pull mode, message push mode enables messages to reach the client system in a more real-time manner, and the complexity of the client system will be reduced (it is no longer necessary to start a scheduled task to call the message pull interface). The disadvantage is that when an exception occurs at the consumer end, the message producer continues to produce messages. Even though we have a retry mechanism, the messages may still be lost due to the limited number of retries.

Because of the characteristics of webhook, when a large number of messages are generated, the message throughput mainly depends on the processing efficiency of the customer webhook message processing service. To ensure the quality of service, the timeout period set for each message push request is 2 seconds. After the processing timeout, it is considered to have failed to send this message. If the retry mechanism is configured, the message will be sent again using the retry mechanism. If the maximum number of retries fails, the message will be discarded and will not be pushed again. It is recommended that developers quickly write the push messages into their own message queue after receiving them to improve the message receiving ability.

Please contact us via email open-team@ezvizlife.com if you'd like receive the message from camera and sensor through message service.

2. Request Protocol Description

Request Method

HTTP POST Content-Type: text/plain

Note: The current http request body is in json format, but the Content-Type of the request header is text/plain.

Request Header

Field	Name	Description
t	Time stamp	Message sending time stamp.
signature	Signature	(Optional) Use hmac+sha1 to sign the data in the message body. See the following security related sections for details.
message_type	Message type	Consistent with the message type in the message subscription, for example: ys.alarm(alarm message), ys.calling(calling message), etc.
Description of header content in the request body

Field	Name	Description
channelNo	Channel number	
deviceId	Device serial number	
messageId	Message id	
messageTime	Message push time	
type	Message type	
Note: The data in the body is the message reported by the transparent transmission device.

Request Body

JSON format, consistent with the message body structure in message subscription results.

Request body example

{
    "body": {
        "data": "0",
        "index": 24409
    },
    "header": {
        "channelNo": 1,
        "deviceId": "D98462102",
        "messageId": "5e57f239793f2b007fecb0de",
        "messageTime": 1582821945396,
        "type": "ys.open.isapi"
    }
}
Response

For a webhook push, if the http return code of the customer webhook service is 200 and the returned content contains the push request message messageId, the push is successful.

Return example

{  
    "messageId": "5e57f239793f2b007fecb0de"
}
Security

The customer must provide https url as the webhook address;
If the signing key is provided when the service is opened, the push request header contains the signature of the message body (the customer verifies the signature after receiving the message); Signature method：signature=hmac_sha1(HTTP request body+ time stamp, secret configured when the customer enables the message push)
3. Cautions

The customer system must design and implement the deployment of the webhook message processing service according to its own device message volume. If the customer webhook message service has insufficient processing capability and causes its own system failure, messages may be lost (a retry mechanism can be configured to retry, but the timeliness will decline, and if the failure lasts too long, the messages may still be lost). It is recommended that the webhook message processing service implemented by the customer directly forwards the push messages to the persistent message queue when receiving them, and then the later business system will consume these messages for business logic processing, so as to improve the efficiency of webhook message pushing and receiving.
The timeout period of the push is 2 seconds. If the customer webhook service takes more than 2 seconds to process the push message, the push will be considered as a failure and the subsequent processing operations for the push failure will be performed.
If the customer webhook message processing service needs the whole cluster to be shut down for upgrading (the service is completely unavailable), there is a risk of message loss. Therefore, if the whole cluster is shut down for maintenance, a processing plan should be prepared.
4. Information Provided When Webhook Is Enabled

Webhook callback address
Push message type (eg：ys.alarm / ys.open.isapi / ys.calling / ys.onoffline / ys.open.ram / ys.iot / ys.auth.update)
Signing key (optional)
Maximum number of retries for push failure (optional, value range: 1~3)
Email address for service downgrade notification (optional)
Appendix 1: Signature sample code (java version)

public static String hmacSha1(String key, String data, Charset bytesEncode) throws NoSuchAlgorithmException, InvalidKeyException {
    SecretKeySpec signingKey = new SecretKeySpec(key.getBytes(bytesEncode), "HmacSHA1");
    Mac mac = Mac.getInstance("HmacSHA1");
    mac.init(signingKey);
    // General method, just implement it yourself (from byte[] to hex string)
    return byteToHexString(mac.doFinal(data.getBytes(bytesEncode)));
}

...
String secret = ... ;//Signing key
String body = ...; //HTTP request body
String timestamp = ...; //HTTP header，field：t
//Verify signature
signature.equals(hmacSha1(secret, body + timestamp, StandardCharsets.UTF_8))
Appendix 2: Callback address receiving template

@RequestMapping(value = "/webhook")
public ResponseEntity<String> webhook(@RequestHeader HttpHeaders header, @RequestBody String body) {
    final List<String> t = header.get("t");
    WebhookMessage receiveMessage = null;
    log.info("Message acquisition time:{}, request header:{},request body:{}",System.currentTimeMillis(),JSON.toJSONString(header),body);
    System.out.println("Message received:"+body);
    try {
        receiveMessage = JSON.parseObject(body, WebhookMessage.class);
        //todo: Process the received message. It is better to send it to other middleware or write it to the database, without affecting the processing of the callback address

    } catch (Exception e) {
        e.printStackTrace();
}
//Must return
    Map<String, String> result = new HashMap<>(1);
    assert receiveMessage != null;
    String messageId = receiveMessage.getHeader().getMessageId();
    result.put("messageId", messageId);
    final ResponseEntity<String> resp = ResponseEntity.ok(JSON.toJSONString(result));
    log.info("Information returned:{}",JSON.toJSONString(result));
    return resp;
}


1. Error code description:

Return Value	Description	Remark
200	Operation completed	
1001	Invalid user name	
1002	The user name is occupied	
1003	Invalid password	
1004	Duplicated password	
1005	No more incorrect password attempts are allowed	
1006	The phone number is registered	
1007	Unregistered phone number	
1008	Invalid phone number	
1009	The user name and phone does not match	
1010	Getting verification code failed	
1011	Incorrect verification code	
1012	Invalid verification code	
1013	The user does not exist	
1014	Incorrect password or appKey	
1015	The user is locked	
1021	Verification parameters exception	
1026	The email is registered	
1031	Unregistered email	
1032	Invalid email	
1041	No more attempts are allowed to get verification code	
1043	No more incorrect verification code attempts are allowed	
2000	The device does not exist	
2001	The camera does not exist	The camera is not registered to Ezviz Cloud. Check the camera network configuration
2003	The device is offline	Refer to Service Center Trouble Shooting Method
2004	Device exception	
2007	Incorrect device serial No.	
2009	The device request timeout	
2030	The device does not support Ezviz Cloud	Check whether the device support Ezviz Cloud. You can also contact our supports: 4007005998
5000	The device is added by yourself	
5001	The device is added by others	
5002	Incorrect device verification code	
7001	The invitation does not exist	
7002	Verifying the invitation failed	
7003	The invited user does not match	
7004	Canceling invitation failed	
7005	Deleting invitation failed	
7006	You cannot invite yourself	
7007	Duplicated invitation	You should call the interface for sharing or deleting the sharing. Troubleshooting: Clear all the sharing data in Ezviz Client and add the device again by calling related interface
10001	Parameters error	Parameter is empty or the format is incorrect
10002	accessToken exception or expired	The accessToken is valid for seven days. It is recommended that you can get the accessToken when the accessToken will be expired or Error Code 10002 appears
10004	The user does not exist	
10005	appKey exception	Return the error code when appKey is incorrect or appKey status is frozen
10006	The IP is limited	
10007	No more calling attempts are allowed	
10009	Signature parameters error	
10012	The third-party account is bound with the Ezviz account	
10013	The APP has no permission to call this interface	
10014	The APPKEY corresponding third-party userId is not bound with the phone	The appKey for getting AccessToken is different from the one set in SDK
10017	appKey does not exist	Fill in the App key applied in the official website
10018	AccessToken does not match with Appkey	Check whether the appKey for getting AccessToken is the same with the one set in SDK.
10019	Password error	
10020	The requesting method is required	
10029	The call frequency exceeds the upper-limit	
10030	appKey and appSecret mismatch.	
10031	The sub-account or the EZVIZ user has no permission	
10032	Sub-account not exist	
10034	Sub-account name already exist	
10035	Getting sub-account AccessToken error	
10036	The sub-account is frozen.	
20001	The channel does not exist	Check whether the camera is added again and the channel parameters are updated
20002	The device does not exist	①The device does not register to Ezviz. Check the network is connected. ②The device serial No. does not exist.
20003	Parameters exception and you need to upgrade the SDK version	
20004	Parameters exception and you need to upgrade the SDK version	
20005	You need to perform SDK security authentication	Security authentication is deleted
20006	Network exception	
20007	The device is offline	Refer to Service Center Check Method
20008	The device response timeout	The device response timeout. Check the network is connected and try again
20009	The device cannot be added to child account	
20010	The device verification code error	The verification code is on the device tag. It contains six upper-cases
20011	Adding device failed.	Check whether the network is connected.
20012	Adding the device failed.	
20013	The device has been added by other users.	
20014	Incorrect device serial No..	
20015	The device does not support the function.	
20016	The current device is formatting.	
20017	The device has been added by yourself.	
20018	The user does not have this device.	Check whether the device belongs to the user.
20019	The device does not support cloud storage service.	
20020	The device is online and is added by yourself.	
20021	The device is online and is not added by the user.	
20022	The device is online and is added by other users.	
20023	The device is offline and is not added by the user.	
20024	The device is offline and is added by the user.	
20025	Duplicated sharing.	Check whether the sharing exists in the account that added the device.
20026	The video does not exist in Video Gallery.	
20029	The device is offline and is added by yourself.	
20030	The user does not have the video in this video gallery.	
20031	The terminal binding enabled, and failed to verify device code.	Disable the terminal binding
20032	The channel does not exist for this user.	
20033	The video shared by yourself cannot be added to favorites.	
20101	Share the video to yourself.	
20102	No corresponding invitation information.	
20103	The friend already exists.	
20104	The friend does not exist.	
20105	The friend status error.	
20106	The corresponding group does not exist.	
20107	You cannot add yourself as friend.	
20108	The current user is not the friend of the added user.	
20109	The corresponding sharing does not exist.	
20110	The friend group does not belong to the current user.	
20111	The friend is not in the status of waiting verification.	
20112	Adding the user in application as friend failed.	
20201	Handling the alarm information failed.	
20202	Handling the leaved message failed.	
20301	The alarm message searched via UUID does not exist.	
20302	The picture searched via UUID does not exist.	
20303	The picture searched via FID does not exist.	
30001	The user doesn't exist	
49999	Data exception.	
50000	The server exception.	
60000	The device does not support PTZ control.	
60001	The user has no PTZ control permission.	
60002	The device PTZ has reached the top limit.	
60003	The device PTZ has reached the bottom limit.	
60004	The device PTZ has reached the left limit.	
60005	The device PTZ has reached the right limit.	
60006	PTZ control failed.	
60007	No more preset can be added.	
60008	The preset number of C6 has reached the limit. You cannot add more preset.	
60009	The preset is calling.	
60010	The preset is the current position.	
60011	The preset does not exist.	
60012	Unknown error.	
60013	The version is the latest one.	
60014	The device is upgrading.	
60015	The device is rebooting.	
60016	The encryption is disabled.	
60017	Capturing failed.	
60018	Upgrading device failed.	
60019	The encryption is enabled.	
60020	The command is not supported.	Check whether the device support the command.
60021	It is current arming/disarming status.	
60022	It is current status.	It is current open or closed status.
60023	Subscription failed.	
60024	Canceling subscription failed.	
60025	Setting people counting failed.	
60026	The device is in privacy mask status.	
60027	The device is mirroring.	
60028	The device is controlling PTZ.	
60029	The device is in two-way audio status.	
60030	No more incorrect card password attempts are allowed. Try again after 24 hours.	
60031	Card password information does not exist.	
60032	Incorrect card password status or the password is expired.	
60033	The card password is not for sale. You can only buy the corresponding device.	
60035	Buying cloud storage server failed.	
60040	The added devices are not in the same LAN with the parent device.	
60041	The added devices are not in the same LAN with the parent device.	
60042	Incorrect password for added device.	
60043	No more devices can be added.	
60044	Network connection for the added device timeout.	
60045	The added device IP conflicts with the one of other channel.	
60046	The added device IP conflicts with the one of parent device.	
60047	The stream type is not supported.	
60048	The bandwidth exceeds the system accessing bandwidth.	
60049	Invalid IP or port.	
60050	The added device is not supported. You should upgrade the device.	
60051	The added device is not supported.	
60052	Incorrect channel No. for added device.	
60053	The resolution of added device is not supported.	
60054	The account for added device is locked.	
60055	Getting stream for the added device error.	
60056	Deleting device failed.	
60057	The deleted device has no linkage.	Check whether there's linkage between IPC and NVR.



1. API List

This section introduces the device operation related APIs.

API List:

No.	Function	Description
1	Add Device	Add the device to the login account.
2	Delete Device	Remove the specified device from the login account.
3	Edit Device Name	Edit the device name.
4	Capture Picture	Capture the current view of the device.
5	Link IPC to NVR	Link IPC to NVR.
6	Delete IPC form NVR	Delete the IPC from the NVR
1.1 Add Device

Function

Add device to this account.

Request Address

{areaDomain}/api/lapp/device/add

Request Method

POST

Request Parameters

Parameter	Type	Description	Required
accessToken	String	The access_token during authentication.	Y
deviceSerial	String	The device serial No..	Y
validateCode	String	The device verification code: six upper cases in the device body.	Y
HTTP Request Message
POST /api/lapp/device/add HTTP/1.1
Host: isgpopen.ezvizlife.com
Content-Type: application/x-www-form-urlencoded
accessToken=at.20h863523v1zfck75qgmwhoy7vl2teqp&deviceSerial=427734888&validateCode=ABCDEF
Returned Data
{
    "code": "200",
    "msg": "Operation succeeded!"
}
Returned Code
Returned Code	Returned Message	Description
200	Operation succeeded.	Requesting succeeded.
10001	Parameters error.	Parameter is empty or the format is incorrect.
10002	accessToken exception or expired.	Get accessToken again.
10005	appKey exception.	appKey is frozen.
20002	Device does not exist.	
20006	Network exception.	Check the network status. Try again.
20007	The device is offline.	Check whether the device is online.
20010	Device verification code error.	Check whether the device verification code is correct.
20011	Adding device failed.	Check whether the network is connected.
20013	Device has been added by others.	The device has been added by other account.
20014	Illegal deviceSerial	
20017	Device has been added by yourself.	The device has been added by this account.
49999	Data exception.	Calling API exception.
1.2 Delete Device

Function

Remove the device from this account.

Request Address

{areaDomain}/api/lapp/device/delete

Request Method

POST

Request Parameters

Parameter	Type	Description	Required
accessToken	String	The access_token during authentication.	Y
deviceSerial	String	The device serial No..	Y
HTTP Request Message
POST /api/lapp/device/delete HTTP/1.1
Host: isgpopen.ezvizlife.com
Content-Type: application/x-www-form-urlencoded
accessToken=at.20h863523v1zfck75qgmwhoy7vl2teqp&deviceSerial=427734888
Returned Data
{
    "code": "200",
    "msg": "Operation succeeded!"
}
Returned Code
Returned Code	Returned Message	Description
200	Operation succeeded.	Requesting succeeded.
10001	Parameters error.	Parameter is empty or the format is incorrect.
10002	accessToken exception or expired.	Get accessToken again.
10005	appKey exception.	appKey is frozen.
20002	Device does not exist.	
20014	Illegal deviceSerial	
20018	The user does not have this device.	Check whether the device belongs to the current account.
49999	Data exception.	Calling API exception.
1.3 Edit Device Name

Function

Edit device name.

Request Address

{areaDomain}/api/lapp/device/name/update

Request Method

POST

Request Parameters

Parameter	Type	Description	Required
accessToken	String	The access_token during authentication.	Y
deviceSerial	String	The device serial No..	Y
deviceName	String	Device name,within 50 bytes and special characters are not supported.	Y
HTTP Request Message
POST /api/lapp/device/name/update HTTP/1.1
Host: isgpopen.ezvizlife.com
Content-Type: application/x-www-form-urlencoded
accessToken=at.cp894sbq65xa5niv0myrfdzma0ja7js1&deviceSerial=0&deviceName=5
Returned Data
{
    "code": "200",
    "msg": "Operation succeeded!"
}
Returned Code
Returned Code	Returned Message	Description
200	Operation succeeded.	Requesting succeeded.
10001	Parameters error.	Parameter is empty or the format is incorrect.
10002	accessToken exception or expired.	Get accessToken again.
10005	appKey exception.	appKey is frozen.
20002	Device does not exist.	
20014	Illegal deviceSerial	
20018	The user does not have this device.	Check whether the device belongs to the current account.
49999	Data exception.	Calling API exception.
1.4 Capture Pictures

Function

Capture the device current view.It is only available for the IPC or IPC linked NVR.

Request Address

{areaDomain}/api/lapp/device/capture

Request Method

POST

Request Parameters

Parameter	Type	Description	Required
accessToken	String	The access_token during authentication.	Y
deviceSerial	String	The device serial No..	Y
channelNo	int	Channel No.. For IPC device, it is 1.	Y
quality	int	quality,0-Smooth,1-HD(720P),2-4CIF,3-1080P,4-400w	N
HTTP Request Message
POST /api/lapp/device/capture HTTP/1.1
Host: isgpopen.ezvizlife.com
Content-Type: application/x-www-form-urlencoded
accessToken=at.12xp95k63bboast3aq0g5hg22q468929&deviceSerial=427734888&channelNo=1
Returned Data
{
    "data": {
        "picUrl": "http://img.ys7.com//group2/M00/74/22/CmGdBVjBVDCAaFNZAAD4cHwdlXA833.jpg"
    },
    "code": "200",
    "msg": "Operation succeeded!"
}
Returned Code
Returned Code	Returned Message	Description
200	Operation succeeded.	Requesting succeeded.
10001	Parameters error.	Parameter is empty or the format is incorrect.
10002	accessToken exception or expired.	Get accessToken again.
10005	appKey exception.	appKey is frozen.
20002	Device does not exist.	
20006	Network exception.	Check the network status. Try again.
20007	The device is offline.	Check whether the device is online.
20008	Device requesting timeout.	No more operations. Try again.
20014	Network exception.	Check the network status. Try again.
20018	The user does not have this device.	Check whether the device belongs to the current account.
20032	The channel does not exist in this user.	Check whether the device has this channel.
49999	Data exception.	Calling the API exception.
60017	Capturing pictures failed.	The device returns fail.
60020	The command is not supported.	Check whether the device supports capturing.
1.5 Link IPC to NVR

Function

This API is used to link IPC to NVR.

Request Address

{areaDomain}/api/lapp/device/ipc/add

Request Method

POST

Request Parameters

Parameter	Type	Description	Required
accessToken	String	The access_token during authentication.	Y
deviceSerial	String	The device serial No..	Y
ipcSerial	String	IPC serial No. to be linked.	Y
channelNo	int	Optional, when it is empty, link IPC to the specified channel, or link IPC to the first channel.	N
validateCode	String	Optional, IPC verification code. By default, it is empty.	N
HTTP Request Message
POST /api/lapp/device/ipc/add HTTP/1.1
Host: isgpopen.ezvizlife.com
Content-Type: application/x-www-form-urlencoded
accessToken=at.0v1ksxnqdu5lxc2fak3ctbiq0r3269y9&deviceSerial=596510666&channelNo=1&ipcSerial=777777777&validateCode=
Returned Data
{
    "code": "200",
    "msg": "Operation succeeded!"
}
Returned Code
Returned Code	Returned Message	Description
200	Operation succeeded.	Requesting succeeded.
10001	Parameters error.	Parameter is empty or the format is incorrect.
10002	accessToken exception or expired.	Get accessToken again.
10005	appKey exception.	appKey is frozen.
20002	Device does not exist.	
20006	Network exception.	Check the network status. Try again.
20007	The device is offline.	Check whether the device is online.
20008	Device requesting timeout.	No more operations. Try again.
20014	Network exception.	Check the network status. Try again.
20018	The user does not have this device.	Check whether the device belongs to the current account.
49999	Data exception.	Calling the API exception.
60012	Unknown error.	The device returns other error code.
60020	The command is not supported.	Check whether the device supports capturing.
60040	The added devices are not in the same LAN.	
60041	The added device is linked to other device or requesting timeout.	
60042	The added device password error.	
60043	The added device exceeds the limit.	
60044	The added device network timeout.	
60045	The added device IP is conflict with that of other channel.	
60046	The added device IP is conflict with that of this device.	
60047	The stream type is not supported.	
60048	The bandwidth exceeds the system accessing bandwidth.	
60049	Illegal IP or port	
60050	The added device version is not supported. You need to upgrade it.	
60051	The added device is not supported.	
60052	The added device channel No. error.	
60053	The added device resolution is not supported.	
60054	The device account is locked.	
60055	The added device streaming error.	Check the IPC stream.
1.6 Delete IPC from NVR

Function

This API is used to remove the IPC from NVR.

Request Address

{areaDomain}/api/lapp/device/ipc/delete

Request Method

POST

Request Parameters

Parameter	Type	Description	Required
accessToken	String	The access_token during authentication.	Y
deviceSerial	String	The device serial No..	Y
ipcSerial	String	IPC serial No. to be linked.	Y
channelNo	int	Optional, when it is empty, link IPC to the specified channel, or link IPC to the first channel.	N
HTTP Request Message
POST /api/lapp/device/ipc/delete HTTP/1.1
Host: isgpopen.ezvizlife.com
Content-Type: application/x-www-form-urlencoded
accessToken=at.0v1ksxnqdu5lxc2fak3ctbiq0r3269y9&deviceSerial=596510666&channelNo=1&ipcSerial=777777777
Returned Data
{
    "code": "200",
    "msg": "Operation succeeded!"
}
Returned Code
Returned Code	Returned Message	Description
200	Operation succeeded.	Requesting succeeded.
10001	Parameters error.	Parameter is empty or the format is incorrect.
10002	accessToken exception or expired.	Get accessToken again.
10005	appKey exception.	appKey is frozen.
20002	Device does not exist.	
20006	Network exception.	Check the network status. Try again.
20007	The device is offline.	Check whether the device is online.
20008	Device requesting timeout.	No more operations. Try again.
20014	Network exception.	Check the network status. Try again.
20018	The user does not have this device.	Check whether the device belongs to the current account.
49999	Data exception.	Calling the API exception.
60012	Unknown error.	The device returns other error code.
60020	The command is not supported.	Check whether the device supports capturing.
60056	Deleting the device failed.	
60057	The device to delete is not linked.	


. API List

Contains the APIs about device information search.

See the following list:

No.	Function	Description
1	Get device list	Get the device list of the current account.
2	Get single device information	Get the specified device information.
3	Get camera list	Get the camera list of the current account.
4	Search captured picture by UUID	Search captured picture by UUID (for Linktom device)
5	Get device status information	Get the specified device status information
6	Get device channel information	Get the information of device channel by device serial
1.1 Get Device List

API Function

Search the device basic information list

Request Address

{areaDomain}/api/lapp/device/list

Request Type

POST

Request Parameters

Parameter	Type	Description	Required
accessToken	String	The access_token during authentication.	Y
pageStart	int	Start page,from 0	N
pageSize	int	Paging size,the default size is 10, the maximum size is 50.	N
HTTP Request Message
POST /api/lapp/device/list HTTP/1.1
Host: isgpopen.ezvizlife.com
Content-Type: application/x-www-form-urlencoded
accessToken=at.dunwhxt2azk02hcn7phqygsybbw0wv6p&pageStart=0&pageSize=2
Return Data
{
    "page": {
        "total": 2,
        "page": 0,
        "size": 2
    },
    "data": [
        {
            "deviceSerial": "427734000",
            "deviceName": "xiaoge device",
            "deviceType": "C1",
            "status": 1,
            "defence": 1,
            "deviceVersion": "V4.2.5 build 151223",
            "updateTime": "2017-09-01 15:30:45"
        },
        {
            "deviceSerial": "519266666",
            "deviceName": "Test",
            "deviceType": "UNKNOWN",
            "status": 0,
            "defence": 0,
            "deviceVersion": "V5.3.0 build 150824",
            "updateTime": "2017-09-01 15:30:45"
        }
    ],
    "code": "200",
    "msg": "Operating succeeded!"
}
Request Parameters
Parameter	Type	Description	Required
deviceSerial	String	Device serial No.	
deviceName	String	Device Name	
deviceType	String	Device Type	
status	int	Online status:0-Offline, 1-Online	
isEncrypt	int	Enable encryption or not:0-No, 1-Yes	
defence	int	Arming and disarming status of A1 device:0-Sleep, 8-Home, 16-Away. ，Arming and disarming status of non-A1 device:0 -Disarm, 1-Arm	
deviceVersion	int	Device version No.	
Returned Code
Returned Code	Returned Message	Description
200	Operation succeeded.	Requesting succeeded.
10001	Parameters error.	Parameter is empty or the format is incorrect.
10002	accessToken exception or expired.	Get accessToken again.
10005	appKey exception.	appKey is frozen.
49999	Data exception.	Calling the API exception.
1.2 Get Single Device Information

API Function

Search the basic information of specified device

Request Address:

{areaDomain}/api/lapp/device/info

Request Type

POST

Request Parameters

Parameter	Type	Description	Required
accessToken	String	The access_token during authentication.	Y
deviceSerial	String	The device serial No..	Y
HTTP Request Message
POST /api/lapp/device/info HTTP/1.1
Host: isgpopen.ezvizlife.com
Content-Type: application/x-www-form-urlencoded
accessToken=at.dunwhxt2azk02hcn7phqygsybbw0wv6p&deviceSerial=427734168
Return Data
{
    "data": {
        "deviceSerial": "427734168",
        "deviceName": "niuxiaoge device",
        "model": "CS-C1-11WPFR",
        "status": 0,
        "defence": 1,
        "isEncrypt": 0
    },
    "code": "200",
    "msg": "Operating succeeded!"
}
Request Parameters
Parameter	Type	Description	Required
deviceSerial	String	Device serial No.	
deviceName	String	Device Name	
model	String	Device model. Example: CS-C2S-21WPFR-WX	
status	int	Online status:0 -Online, 1- Online	
defence	int	Arming and disarming status of A1 device:0-Sleep, 8-Home, 16-Away. ，Arming and disarming status of non-A1 device:0 -Disarm, 1-Arm	
isEncrypt	int	Enable encryption or not:0-No, 1-Yes	
Returned Code
Returned Code	Returned Message	Description
200	Operation succeeded.	Requesting succeeded.
10001	Parameters error.	Parameter is empty or the format is incorrect.
10002	accessToken exception or expired.	Get accessToken again.
10005	appKey exception.	appKey is frozen.
20002	The device does not exist.	
20014	Illegal deviceSerial	
20018	The channel does not exist.	The channel does not exist.
49999	Data exception.	Calling the API exception.
1.3 Get Camera List

API Function

Get camera list

Request Address

{areaDomain}/api/lapp/camera/list

Request Type

POST

Request Parameters

Parameter	Type	Description	Required
accessToken	String	The access_token during authentication.	Y
pageStart	int	Start page,from 0	N
pageSize	int	aging size,he default size is 10, the maximum size is 50.	N
HTTP Request Message
POST /api/lapp/camera/list HTTP/1.1
Host: isgpopen.ezvizlife.com
Content-Type: application/x-www-form-urlencoded
accessToken=at.20h863523v1zfck75qgmwhoy7vl2teqp&pageStart=0&pageSize=2
HTTP Request Message
{
    "page": {
        "total": 2,
        "page": 0,
        "size": 10
    },
    "data": [
        {
            "deviceSerial": "427734444",
            "channelNo": 1,
            "channelName": "C1(427734444)",
            "status": 1,
            "isShared": "1",
            "picUrl": "http://img.ys7.com/group1/M00/02/B4/CmGCA1dRGyuAdJ_RAABJBCB_Re4796.jpg",
            "isEncrypt": 1,
            "videoLevel": 2
        },
        {
            "deviceSerial": "519544444",
            "channelNo": 1,
            "channelName": "C2C(519544444)",
            "status": 0,
            "isShared": "2",
            "picUrl": "https://i.ys7.com/assets/imgs/public/homeDevice.jpeg",
            "isEncrypt": 0,
            "videoLevel": 2
        }
    ],
    "code": "200",
    "msg": "Operating succeeded!"
}
Request Parameters
Parameter	Type	Description	Required
deviceSerial	String	Device serial No.	
channelNo	String	Channel No.	
channelName	String	Channel name	
status	int	Online status:0 -Online, 1- Online	
isShared	String	Sharing status:1-Share by, 0-Unshared, 2-Share to	
picUrl	String	Picture address (large icon).If the perface is set in the EZVIZ client, return perface picture. Otherwise, return default picture.	
isEncrypt	int	Enable encryption or not:0-No, 1-Yes	
videoLevel	int	Video quality:0 -Fluent, 1-Equalization, 2-HD, 3-Super Definition	
Returned Code
Returned Code	Returned Message	Description
200	Operation succeeded.	Requesting succeeded.
10001	Parameters error.	Parameter is empty or the format is incorrect.
10002	accessToken exception or expired.	Get accessToken again.
10005	appKey exception.	appKey is frozen.
20002	The device does not exist.	
20014	Illegal deviceSerial	
20018	The channel does not exist.	The channel does not exist.
49999	Data exception.	Calling the API exception.
1.4 Search Captured Picture by UUID (for Linktom Device)（Device connectivity is used）

API Function

This API is used for Linktom device to search the captured picture by UUID.

Request Address

{areaDomain}/api/lapp/device/uuid/picture

Request Type

POST

Request Parameters

Parameter	Type	Description	Required
accessToken	String	The access_token during authentication.	Y
uuid	String	The UUUID returned during the device SDK capture.	Y
size	int	Picture size, ranging from 0 to 1280	Y
HTTP Request Message
POST /api/lapp/device/uuid/picture HTTP/1.1
Host: isgpopen.ezvizlife.com
Content-Type: application/x-www-form-urlencoded
accessToken=at.9mqitppidgce4y8n54ranvyqc9fjtsrl&uuid=09076e76501644989b63ba0016ec5776&size=100
Return Data
{
    "data": {
        "picUrl": "https://wuhancloudpictest.ys7.com:8083/HIK_1468308471_AF28AE8DD5A0e83e_FA163E0CE33A150000797?isEncrypted=0&isCloudStored=0&x=1280&session=hik%24shipin7%231%23USK%23"
    },
    "code": "200",
    "msg": "Operating succeeded!"
}
Return Field
Field Name	Type	Description
picUrl	String	Picture path
Returned Code
Returned Code	Returned Message	Description
200	Operation succeeded.	Requesting succeeded.
10001	Parameters error.	Parameter is empty or the format is incorrect.
10002	accessToken exception or expired.	Get accessToken again.
10005	appKey exception.	appKey is frozen.
20301	The device does not exist.	
20302	Illegal deviceSerial	
20303	The channel does not exist.	The channel does not exist.
49999	Data exception.	API call exception.
1.5 Get the device status information

API Function：

This API is used for Link device serial to search the device status.

Request Address:

{areaDomain}/api/lapp/device/status/get

Request Type

POST

Sub token Request minimum permission

"Permission":"Get" "Resource":"dev:serial"

Request Parameter

Parameter	Type	Description	Required
accessToken	String	The access_token during authentication	Y
deviceSerial	String	Device serial No	Y
channel	int	channel number,default is 1	N
HTTP Request Message
POST /api/lapp/device/status/get HTTP/1.1
Host: isgpopen.ezvizlife.com
Content-Type: application/x-www-form-urlencoded

accessToken=at.20h863523v1zfck75qgmwhoy7vl2teqp&deviceSerial=427734168&channel=1
Return Data
{
    "data": {
        "privacyStatus": 0,
        "pirStatus": -2,
        "alarmSoundMode": 2,
        "battryStatus": -1,
        "lockSignal": -1,
        "diskNum": 1,
        "diskState": "0---------------",
        "cloudType": 0,
        "cloudStatus": 2,
        "nvrDiskNum": 1,
        "nvrDiskState": "0---------------"
    },
    "code": "200",
    "msg": "Operating succeeded!"
}
Return Field:
Field Name	Type	Description
privacyStatus	int	Privacy state: 0：close privacy state ；1：open privacy state；-1：initial value；2：-not support ,C1 dedicated,-2:device not report or device not support status
pirStatus	int	infrared state，1：open infrared，0：close infrared，-1：initial value，2：not support ,-2:device not report or device not support status
alarmSoundMode	int	Audio Alarm mode ，0：short voice ，1：long voice，2：mute,3:custom voice,-1:device not report or device not support status
battryStatus	int	battryStatus,1 to 100(%)，-1:device not report or device not support status
lockSignal	int	Locks and gateway between the wireless signal，more than 10 percent difference value will report ,-1:device not report or device not support status
diskNum	int	Mount the sd drive number,-1:device not report or device not support status
diskState	String	sd drive status:0:normal; 1:wrong storage medium; 2:unformatted; 3:formatting;return type:one disk"0---------------",two disks "00--------------",by parity of reasoning;-1:device not report or device not support status
cloudStatus	int	cloud storage status: -2:device not support; -1: not available; 0: not activated; 1: activated; 2: past due
nvrDiskNum	int	NVR mount disk number: -1:device not report or device not support; -2:not link,Similar to the NVR type of superior equipment
nvrDiskState	String	NVRmount disk status:0:normal; 1:wrong storage medium; 2:unformatted; 3:formatting;return type:one disk"0---------------",two disks "00--------------",by parity of reasoning;-1:device not report or device not support status; -2:not link,Similar to the NVR type of superior equipment
Returned Code
Returned Code	Returned Message	Description
200	Operation succeeded.	Requesting succeeded.
10001	Parameters error	Parameter is empty or the format is incorrect
10002	accessToken exception or expired.	Get accessToken again.
10005	appKey exception.	appKey is frozen.
20002	Device does not exist.	
20014	Illegal deviceSerial	
20018	The user doesn't own the device.	
49999	Data error	API call exception.
1.6 Get device channel information

API Function:

This API is used for get the channel information of device which is selected

Request Address:

{areaDomain}/api/lapp/device/camera/list

Request Type

POST

Request Parameters:

Parameter	Type	Description	Required
accessToken	String	The access_token during authentication.	Y
deviceSerial	String	Device serial No.	Y
HTTP Request Message
POST /api/lapp/device/camera/list HTTP/1.1
Host: isgpopen.ezvizlife.com
Content-Type: application/x-www-form-urlencoded

accessToken=at.20h863523v1zfck75qgmwhoy7vl2teqp&deviceSerial=427734222
Return Data
{
    "data": [
        {
            "deviceSerial": "427734222",
            "ipcSerial": "427734222",
            "channelNo": 1,
            "deviceName": "My(427734222)427734222",
            "channelName": "My(427734222)427734222",
            "status": 1,
            "isShared": "0",
            "picUrl": "https://portal.ys7.com/assets/imgs/public/homeDevice.jpeg",
            "isEncrypt": 0,
            "videoLevel": 2,
            "relatedIpc": false
        }
    ],
    "code": "200",
    "msg": "Operating succeeded!"
}
Return Field:
Field Name	Type	Description
deviceSerial	String	Device serial No.
ipcSerial	String	IPC serial No.
channelNo	int	Channel No
deviceName	String	Device name
channelName	String	Dhannel name
status	int	Online status：0-offline，1-online,-1-device not report
isShared	String	share status : 1-share to other，0-not share to other，2-is shared(this camera is shared by others)
picUrl	String	picture url(big picture )，If user has set front picture,it will get front,or it will return default picture
isEncrypt	int	Is encrypt:0：not encrypt,1：encrypt
videoLevel	int	Video Level:0-smooth,1-BD,2-HD, 3-FHD
relatedIpc	boolean	This channel is related with IPC：true，false. Device in this channel is not reported or this channel has no device related will return false
TIPS：Get the channel information . If the NVR automaticly reports the information of IPC which has been related ,it will returns IPC's information . If the NVR never report the IPC's information .it will get nothing.

Returned Code
Returned Code	Returned Message	Description
200	Operation succeeded.	Requesting succeeded.
10001	Parameters error.	Parameter is empty or the format is incorrect.
10002	accessToken exception or expired.	Get accessToken again.
10005	appKey exception.	appKey is frozen.
20002	Device does not exist.	
20014	Illegal deviceSerial	
20018	The user doesn't own the device.	
30001	The user doesn't exist	
49999	Data error	API call exception.



 API List

Contains the APIs used for enabling or disabling device function status.

See the following list:

No.	Function	Description
1	Arming and disarming	Set the device action detection status
2	Disable device video encryption	Disable device video encryption
3	Enable device video encryption	Enable device video encryption
4	Get audio prompt status of Wi-Fi configuration	Get audio prompt status of Wi-Fi configuration or device reboot.
5	Set audio prompt for Wi-Fi configuration	Set audio prompt for Wi-Fi configuration or device reboot.
6	Get video tampering status	Get video tampering status
7	Set video tampering status	Set video tampering status
8	Get sound source positioning status	Get sound source positioning status
9	Set sound source positioning status	Set sound source positioning status
10	Get device arming and disarming schedule	Get device arming and disarming schedule (action detection)
11	Set device arming and disarming schedule	Set device arming and disarming schedule (action detection)
12	Get device microphone switch status	Get device microphone switch status
13	Set device microphone switch status	Set device microphone switch status
14	Set configuration of pir area	Set configuration of pir area
15	Get configuration of pir area	Get configuration of pir area
16	Set chime type	Set chime type
17	Get chime type	Get chime type
18	Set infrared type	Set infrared type
19	Get infrared type	Get infrared type
20	Get device time zone	Get device time zone
21	Get time zone list	Get time zone list
22	Set device time zone	Set device time zone
23	Get device capability	Get device capability
24	Get device language	Get device language
25	Set device language	Set device language
1.1 Arming and Disarming

API Function

Edit the device arming and disarming status (action detection switch), realize the arming and disarming function.

Request Address

{areaDomain}/api/lapp/device/defence/set

Request Type

POST

Request Parameters

Parameter Name	Type	Description	Required
accessToken	String	Obtained access_token during assigning permission	Y
deviceSerial	String	Device serial No.	Y
isDefence	int	Arming and disarming status of A1 device: 0-Sleep, 8-Home, 16-Away. Arming and disarming status of non-A1 device: 0 -Disarm, 1-Arm	Y
HTTP Request Message
POST /api/lapp/device/encrypt/off HTTP/1.1                
Host: isgpopen.ezvizlife.com
Content-Type: application/x-www-form-urlencoded
accessToken=at.8z25h2063dapeus7c99bb0r6e0kjfjz5&deviceSerial=427734888&validateCode=ABCDEF
Return Data
{
    "code": "200",
    "msg": "Operating succeeded!"
}
Return Code
Returned Code	Returned Infromation	Description
200	Operation succeeded.	Requesting succeeded.
10001	Parameters error.	Parameters are empty or the format is incorrect.
10002	accessToken exception or is expired.	Get accessToken again.
10005	appKey exception.	appKey is frozen.
20002	Device does not exist.	
20006	Network exception.	Check the device network status. Try later.
20007	Device offline.	Check the device online status.
20008	Device response overtime.	Too many operations. Try later.
20014	Illegal deviceSerial.	
20018	The user does not have this device.	Check whether the device belongs to the current account.
49999	Data exception.	Calling the API exception.
1.2 Disable Device Video Encryption

API Function

Disable device video encryption by verification code

Request Address

{areaDomain}/api/lapp/device/encrypt/off

Request Type

POST

Request Parameters

Parameter Name	Type	Description	Required
accessToken	String	Obtained access_token during assigning permission	Y
deviceSerial	String	Device serial No.	Y
validateCode	String	device verification code, 6-bit upper case letters on the physical device.	Y
HTTP Request Message
POST /api/lapp/device/encrypt/off HTTP/1.1
Host: isgpopen.ezvizlife.com
Content-Type: application/x-www-form-urlencoded
accessToken=at.8z25h2063dapeus7c99bb0r6e0kjfjz5&deviceSerial=427734888&validateCode=ABCDEF
Return Data
{
    "code": "200",
    "msg": "Operating succeeded!"
}
Return Code
Returned Code	Returned Infromation	Description
200	Operation succeeded.	Requesting succeeded.
10001	Parameters error.	Parameters are empty or the format is incorrect.
10002	accessToken exception or is expired.	Get accessToken again.
10005	appKey exception.	appKey is frozen.
20002	Device does not exist.	
20006	Network exception.	Check the device network status. Try later.
20007	Device offline.	Check the device online status.
20008	Device response overtime.	Too many operations. Try later.
20010	Device verification code error.	Check the device verification code.
20018	The user does not have this device.	Check whether the device belongs to the current account.
49999	Data exception.	Calling the API exception.
60016	Encryption is already disabled.	The device encryption is already disabled.
1.3 Enable Device Video Encryption

API Function

Disable device video encryption.

Request Address

{areaDomain}/api/lapp/device/encrypt/on

Request Type

POST

Request Parameters

Parameter Name	Type	Description	Required
accessToken	String	Obtained access_token during assigning permission	Y
deviceSerial	String	Device serial No.	Y
HTTP Request Message
POST /api/lapp/device/encrypt/on HTTP/1.1
Host: isgpopen.ezvizlife.com
Content-Type: application/x-www-form-urlencoded
accessToken=at.8z25h2063dapeus7c99bb0r6e0kjfjz5&deviceSerial=427734888
Return Data
{
    "code": "200",
    "msg": "Operating succeeded!"
}
Return Code
Returned Code	Returned Infromation	Description
200	Operation succeeded.	Requesting succeeded.
10001	Parameters error.	Parameters are empty or the format is incorrect.
10002	accessToken exception or is expired.	Get accessToken again.
10005	appKey exception.	appKey is frozen.
20002	Device does not exist.	
20006	Network exception.	Check the device network status. Try later.
20007	Device offline.	Check the device online status.
20008	Device response overtime.	Too many operations. Try later.
20014	Illegal deviceSerial.	
20018	The user does not have this device.	Check whether the device belongs to the current account.
49999	Data exception.	Calling the API exception.
60019	Encryption is already enabled.	The device encryption is already enabled.
1.4 Get Audio Prompt Status of Wi-Fi Configuration

API Function
This API is used to get the audio prompt status of Wi-Fi configuration or device reboot.

Request Address

{areaDomain}/api/lapp/device/sound/switch/status

Request Type

POST

Request Parameters

Parameter Name	Type	Description	Required
accessToken	String	Obtained access_token during assigning permission	Y
deviceSerial	String	Device serial No.	Y
HTTP Request Message
POST /api/lapp/device/sound/switch/status HTTP/1.1
Host: isgpopen.ezvizlife.com
Content-Type: application/x-www-form-urlencoded
accessToken=at.9mqitppidgce4y8n54ranvyqc9fjtsrl&deviceSerial=502608888
Return Data
{
    "data": {
        "deviceSerial": "502608888",
        "channelNo": 1,
        "enable": 1
    },
    "code": "200",
    "msg": "Operating succeeded!"
}
Return Field
Parameter Name	Type	Description
deviceSerial	String	Device serial No.
channelNo	String	Channel No.
enable	int	Status: 0-Disable, 1-Enable
Return Code
Returned Code	Returned Infromation	Description
200	Operation succeeded.	Requesting succeeded.
10001	Parameters error.	Parameters are empty or the format is incorrect.
10002	accessToken exception or is expired.	Get accessToken again.
10004	The user does not exist.	
10005	appKey exception.	appKey is frozen.
20002	Device does not exist.	
20014	Illegal deviceSerial.	
20018	The user does not have this device.	Check whether the device belongs to the current account.
49999	Data exception.	Calling the API exception.
1.5 Set Audio Prompt for Wi-Fi Configuration

API Function

This API is used to set the audio prompt for Wi-Fi configuration or device reboot.

Request Address

{areaDomain}/api/lapp/device/sound/switch/set

Request Type

POST

Request Parameters

Parameter Name	Type	Description	Required
accessToken	String	Obtained access_token during assigning permission	Y
deviceSerial	String	Device serial No.	Y
enable	int	Status:0-Disable, 1-Enable	Y
channelNo	int	Channel No., no transmission means the device itself.	N
Channel No., no transmission means the device itself.
POST /api/lapp/device/sound/switch/set HTTP/1.1
Host: isgpopen.ezvizlife.com
Content-Type: application/x-www-form-urlencoded
accessToken=at.9mqitppidgce4y8n54ranvyqc9fjtsrl&deviceSerial=596510888&enable=1&channelNo=1
Return Data
{
    "code": "200",
    "msg": "Operating succeeded!"
}
Return Code
Returned Code	Returned Infromation	Description
200	Operation succeeded.	Requesting succeeded.
10001	Parameters error.	Parameters are empty or the format is incorrect.
10002	accessToken exception or is expired.	Get accessToken again.
10005	appKey exception.	appKey is frozen.
20002	Device does not exist.	
20006	Network exception.	Check the device network status. Try later.
20007	Device offline.	Check the device online status.
20008	Device response overtime.	Too many operations. Try later.
20014	Illegal deviceSerial.	
20018	The user does not have this device.	Check whether the device belongs to the current account.
20032	The channel does not exist.	The channel does not exist.
49999	Data exception.	API call exception
60020	This command is not supported.	The device does not support the people counting funcrion.
60022	Already the current status.	Already the current status.
1.6 Get Video Tampering Status

API Function

This API is used to get the video tampering status (should be supported by device)

Request Address

{areaDomain}/api/lapp/device/scene/switch/status

Request Type

POST

Request Parameters

Parameter Name	Type	Description	Required
accessToken	String	Obtained access_token during assigning permission	Y
deviceSerial	String	Device serial No.	Y
HTTP Request Message
POST /api/lapp/device/scene/switch/status HTTP/1.1
Host: isgpopen.ezvizlife.com
Content-Type: application/x-www-form-urlencoded
accessToken=at.0v1ksxnqdu5lxc2fak3ctbiq0r3269y9&deviceSerial=596510666
Return Data
{
    "data": {
        "deviceSerial": "596510666",
        "channelNo": 1,
        "enable": 1
    },
    "code": "200",
    "msg": "Operating succeeded!"
}
Return Field
Parameter Name	Type	Description	Required
deviceSerial	String	Device serial No.	Y
channelNo	int	Channel No.	N
enable	int	Status:0-Disable, 1-Enable	Y
Return Code
Returned Code	Returned Infromation	Description
200	Operation succeeded.	Requesting succeeded.
10001	Parameters error.	Parameters are empty or the format is incorrect.
10002	accessToken exception or is expired.	Get accessToken again.
10004	The user does not exist.	
10005	appKey exception.	appKey is frozen.
20002	Device does not exist.	
20014	Illegal deviceSerial.	
20018	The user does not have this device.	Check whether the device belongs to the current account.
49999	Data exception.	Calling the API exception.
1.7 Set Video Tampering Status

API Function
This API is used to set the video tampering status (should be supported by device)

Request Address

{areaDomain}/api/lapp/device/scene/switch/set

Request Type

POST

Request Parameters

Parameter Name	Type	Description	Required
accessToken	String	Obtained access_token during assigning permission	Y
deviceSerial	String	Device serial No.	Y
enable	int	Status:0-Disable, 1-Enable	Y
channelNo	int	Channel No., no transmission means the device itself.	N
HTTP Request Message
POST /api/lapp/device/scene/switch/set HTTP/1.1
Host: isgpopen.ezvizlife.com
Content-Type: application/x-www-form-urlencoded
accessToken=at.0v1ksxnqdu5lxc2fak3ctbiq0r3269y9&deviceSerial=596510666&channelNo=1&enable=1
Return Data
{
    "code": "200",
    "msg": "Operating succeeded!"
}
Return Code
Returned Code	Returned Infromation	Description
200	Operation succeeded.	Requesting succeeded.
10001	Parameters error.	Parameters are empty or the format is incorrect.
10002	accessToken exception or is expired.	Get accessToken again.
10005	appKey exception.	appKey is frozen.
20002	Device does not exist.	
20006	Network exception.	Check the device network status. Try later.
20007	Device offline.	Check the device online status.
20008	Device response overtime.	Too many operations. Try later.
20014	Illegal deviceSerial.	
20018	The user does not have this device.	Check whether the device belongs to the current account.
20032	The channel does not exist.	The channel does not exist.
49999	Data exception.	API call exception
60020	This command is not supported.	The device does not support the people counting funcrion.
60022	Already the current status.	Already the current status.
1.8 Get Sound Source Positioning Status

API Function

This API is used to get the sound source positioning status (the device should support sound source positioning function)

Request Address

{areaDomain}/api/lapp/device/ssl/switch/status

Request Type

POST

Request Parameters

Parameter Name	Type	Description	Required
accessToken	String	Obtained access_token during assigning permission	Y
deviceSerial	String	Device serial No.	Y
HTTP Request Message
POST /api/lapp/device/scene/switch/status HTTP/1.1
Host: isgpopen.ezvizlife.com
Content-Type: application/x-www-form-urlencoded
accessToken=at.0v1ksxnqdu5lxc2fak3ctbiq0r3269y9&deviceSerial=596510666
Return Data
{
    "data": {
        "deviceSerial": "596510666",
        "channelNo": 1,
        "enable": 1
    },
    "code": "200",
    "msg": "Operating succeeded!"
}
Return Field
Parameter Name	Type	Description
deviceSerial	String	String Device serial No.
channelNo	int	int Channel No.
enable	int	Status: 0-Disable, 1-Enable
Return Code
Returned Code	Returned Infromation	Description
200	Operation succeeded.	Requesting succeeded.
10001	Parameters error.	Parameters are empty or the format is incorrect.
10002	accessToken exception or is expired.	Get accessToken again.
10004	The user does not exist.	
10005	appKey exception.	appKey is frozen.
20002	Device does not exist.	
20014	Illegal deviceSerial.	
20018	The user does not have this device.	Check whether the device belongs to the current account.
49999	Data exception.	Calling the API exception.
60020	This command is not supported.	The device does not support the people counting funcrion.
1.9 Set Sound Source Positioning Status

API Function
This API is used to set the sound source positioning status (the device should support sound source positioning function)

Request Address

{areaDomain}/api/lapp/device/ssl/switch/set

Request Type

POST

Request Parameters

Parameter Name	Type	Description	Required
accessToken	String	Obtained access_token during assigning permission	Y
deviceSerial	String	Device serial No.	Y
enable	int	Status:0-Disable, 1-Enable	Y
channelNo	int	Channel No., no transmission means the device itself.	N
HTTP Request Message
POST /api/lapp/device/scene/switch/set HTTP/1.1
Host: isgpopen.ezvizlife.com
Content-Type: application/x-www-form-urlencoded
accessToken=at.0v1ksxnqdu5lxc2fak3ctbiq0r3269y9&deviceSerial=596510666&channelNo=1&enable=1
Return Data
{
    "code": "200",
    "msg": "Operating succeeded!"
}
Return Code
Returned Code	Returned Infromation	Description
200	Operation succeeded.	Requesting succeeded.
10001	Parameters error.	Parameters are empty or the format is incorrect.
10002	accessToken exception or is expired.	Get accessToken again.
10005	appKey exception.	appKey is frozen.
20002	Device does not exist.	
20006	Network exception.	Check the device network status. Try later.
20007	Device offline.	Check the device online status.
20008	Device response overtime.	Too many operations. Try later.
20014	Illegal deviceSerial.	
20018	The user does not have this device.	Check whether the device belongs to the current account.
20032	The channel does not exist.	The channel does not exist.
49999	Data exception.	API call exception
60020	This command is not supported.	The device does not support the people counting funcrion.
60022	Already the current status.	Already the current status.
1.10 Get Device Arming and Disarming Schedule

API Function
This API is used to get the device arming and disarming schedule (the device should support arming and disarming schedule)

Request Address

{areaDomain}/api/lapp/device/defence/plan/get

Request Type

POST

Request Parameters

Parameter Name	Type	Description	Required
accessToken	String	Obtained access_token during assigning permission	Y
deviceSerial	String	Device serial No.	Y
channelNo	int	Channel No., no transmission means the device itself.	N
HTTP Request Message
POST /api/lapp/device/defence/plan/get HTTP/1.1
Host: isgpopen.ezvizlife.com
Content-Type: application/x-www-form-urlencoded
accessToken=at.dunwhxt2azk02hcn7phqygsybbw0wv6p&deviceSerial=427734888&channelNo=1
Return Data
{
    "data": {
        "startTime": "23:20",
        "stopTime": "23:21",
        "period": "0,1,6",
        "enable": 0
    },
    "code": "200",
    "msg": "Operating succeeded!"
}
Return Field
Parameter Name	Type	Description
startTime	String	Start time, for example: 6:00. By default, start time is 00:00
stopTime	String	End time, for example: 16:00, n00:00 means 00:00 of the next day.
period	String	Monday to Sunday, represented by 0 to 6, separate with comma.
enable	int	Enable or not: 1- Ennable, 0-Disable
Return Code
Returned Code	Returned Infromation	Description
200	Operation succeeded.	Requesting succeeded.
10001	Parameters error.	Parameters are empty or the format is incorrect.
10002	accessToken exception or is expired.	Get accessToken again.
10004	The user does not exist.	
10005	appKey exception.	appKey is frozen.
20002	Device does not exist.	
20014	Illegal deviceSerial.	
20018	The user does not have this device.	Check whether the device belongs to the current account.
20032	The channel does not exist.	The channel does not exist.
49999	Data exception.	API call exception
60020	This command is not supported.	The device does not support the people counting funcrion.
1.11 Set Device Arming and Disarming Schedule

API Function
This API is used to set the device arming and disarming (action detection) schedule (the device should support arming and disarming schedule)

Request Address

{areaDomain}/api/lapp/device/defence/plan/set

Request Type

POST

Request Parameters

Parameter Name	Type	Description	Required
accessToken	String	Obtained access_token during assigning permission	Y
deviceSerial	String	Device serial No.	Y
channelNo	int	Channel No., no transmission means the device itself.	N
startTime	String	Start time, for example: 6:00. By default, start time is 00:00	N
stopTime	String	End time, for example: 16:00, n00:00 means 00:00 of the next day.	N
period	String	Monday to Sunday, represented by 0 to 6, separate with comma.	N
enable	String	Enable or not: 1- Ennable, 0-Disable. By default, it is 1.	N
HTTP Request Message
POST /api/lapp/device/defence/plan/set HTTP/1.1
Host: isgpopen.ezvizlife.com
Content-Type: application/x-www-form-urlencoded
accessToken=at.dunwhxt2azk02hcn7phqygsybbw0wv6p&deviceSerial=427734888&channelNo=1&period=0%2C1%2C6&startTime=23%3A20&stopTime=23%3A21&enable=0
Return Data
{
    "code": "200",
    "msg": "Operating succeeded!"
}
Return Code
Returned Code	Returned Infromation	Description
200	Operation succeeded.	Requesting succeeded.
10001	Parameters error.	Parameters are empty or the format is incorrect.
10002	accessToken exception or is expired.	Get accessToken again.
10005	appKey exception.	appKey is frozen.
20002	Device does not exist.	
20006	Network exception.	Check the device network status. Try later.
20007	Device offline.	Check the device online status.
20008	Device response overtime.	Too many operations. Try later.
20014	Illegal deviceSerial.	
20018	The user does not have this device.	Check whether the device belongs to the current account.
20032	The channel does not exist.	The channel does not exist.
49999	Data exception.	API call exception
60020	This command is not supported.	The device does not support the people counting funcrion.
1.12 Get device microphone switch status

Function

This API is used to get device microphone switch status.

Requesting Address

{areaDomain}/api/lapp/camera/video/sound/status

Requesting Parameters

POST

Requesting Parameters

Parameter	Type	Description	Required
accessToken	String	The access_token obtained during authentication.	Y
deviceSerial	String	The device serial No..	Y
HTTP Requesting Report
POST /api/lapp/camera/video/sound/status HTTP/1.1
Host: isgpopen.ezvizlife.com
Content-Type: application/x-www-form-urlencoded

accessToken=at.0v1ksxnqdu5lxc2fak3ctbiq0r3269y9&deviceSerial=596510666
Returned Data
{
  "data": [
      {
          "deviceSerial": "596510666",
          "channelNo": 1,
          "enable": "1"
      }
  ],
    "code": "200",
    "msg": "Operation succeeded!"
}
Returned Code
Returned Code	Returned Infromation	Description
200	Operation succeeded.	Requesting succeeded.
10001	Parameters error.	Parameters are empty or the format is incorrect.
10002	accessToken exception or is expired.	Get accessToken again.
10005	appKey exception.	appKey is frozen.
20002	Device does not exist.	
20006	Network exception.	Check the device network status. Try later.
20007	Device offline.	Check the device online status.
20008	Device response overtime.	Too many operations. Try later.
20014	Illegal deviceSerial.	
20018	The user does not have this device.	Check whether the device belongs to the current account.
49999	Data exception.	Calling the API exception.
60020	Subscription failed.	Calling the API failed.
1.13 Set device microphone switch status

Function

This API is used to set device microphone switch status.

Request Address

{areaDomain}/api/lapp/camera/video/sound/set

Request Type

POST

Request Parameters

Parameter Name	Description	Type	Required
accessToken	String	Obtained access_token during assigning permission	Y
deviceSerial	String	Device serial No.	Y
enable	String	Status: 0-Disable, 1-Enable	Y
HTTP Request Message
POST /api/lapp/camera/video/sound/set HTTP/1.1
Host: isgpopen.ezvizlife.com
Content-Type: application/x-www-form-urlencoded

accessToken=at.0v1ksxnqdu5lxc2fak3ctbiq0r3269y9&deviceSerial=596510666&enable=1
Return Data
{
    "code": "200",
    "msg": "Operating succeeded!"
}
Return Code
Return Code	Return Information	Description
200	Operation succeeded.	Requesting succeeded.
10001	Parameters error.	Parameters are empty or the format is incorrect.
10002	accessToken exception or is expired.	Get accessToken again.
10005	appKey exception.	appKey is frozen.
20002	Device does not exist.	
20006	Network exception.	Check the device network status. Try later.
20007	Device offline.	Check the device online status.
20008	Device response overtime.	Too many operations. Try later.
20014	Illegal deviceSerial.	
20018	The user does not have this device.	Check whether the device belongs to the current account.
49999	Data exception.	Calling the API exception.
60020	Subscription failed.	Calling the API failed.
1.14 Set configuration of pir area

Function

This API is used to set configuration of device's pir area.

Request Address

{areaDomain}/api/lapp/device/pir/set

Request Type

POST

Request Parameters

Parameter Name	Description	Type	Required
accessToken	String	Obtained access_token during assigning permission	Y
deviceSerial	String	Device serial No.	Y
channelNo	int	Channel No., no transmission means the device itself.	N
area	String	pir area . if the value of area is 1,3,6,7
Selected area is
No.	1	2	3
1	0	0	Y
2	0	Y	Y
3	Y	Y	0
4	Y	Y	Y
Y
Every number in param area means the row of area.
Converting decimal to binary , All of 1 area is selected Rows and columns can get through itGet configuration of pir area

HTTP Request Message
POST //api/lapp/device/pir/set HTTP/1.1
Host: isgpopen.ezvizlife.com
Content-Type: application/x-www-form-urlencoded

accessToken=at.0v1ksxnqdu5lxc2fak3ctbiq0r3269y9&deviceSerial=596510666&enable=1
Return Data
{
    "code": "200",
    "msg": "Operating succeeded!"
}
Return Code
Return Code	Return Information	Description
200	Operation succeeded.	Requesting succeeded.
10001	Parameters error.	Parameters are empty or the format is incorrect.
10002	accessToken exception or is expired.	Get accessToken again.
10005	appKey exception.	appKey is frozen.
20002	Device does not exist.	
20006	Network exception.	Check the device network status. Try later.
20007	Device offline.	Check the device online status.
20008	Device response overtime.	Too many operations. Try later.
20014	Illegal deviceSerial.	
20018	The user does not have this device.	Check whether the device belongs to the current account.
49999	Data exception.	Calling the API exception.
60020	Subscription failed.	Calling the API failed.
1.15 Get configuration of pir area

Function

This API is used to get configuration of device's pir area.

Request Address

{areaDomain}/api/lapp/device/pir/get

Request Type

POST

Request Parameters

Parameter Name	Description	Type	Required
accessToken	String	Obtained access_token during assigning permission	Y
deviceSerial	String	Device serial No.	Y
channelNo	int	Channel No., no transmission means the device itself.	N
HTTP Request Message
POST /api/lapp/device/pir/get HTTP/1.1
Host: isgpopen.ezvizlife.com
Content-Type: application/x-www-form-urlencoded

accessToken=at.0v1ksxnqdu5lxc2fak3ctbiq0r3269y9&deviceSerial=596510666&enable=1
Return Data
{
    "data": {
        "deviceSerial": "C24899350",
        "channelNo": 1,
        "rows": 3,
        "columns": 4,
        "area": [
          1,
          9,
          13
        ]
      },
"code": "200",
"msg": "Operation succeeded"
}
Return Field
Parameter Name	Type	Description
devceSerial	String	Device serial No.
channelNo	int	Channel No.
rows	int	pir row number
columns	int	pir column number
area	array	pir area . if the value of area is 1,3,6,7
Selected area is
No.	1	2	3
1	0	0	Y
2	0	Y	Y
3	Y	Y	0
4	Y	Y	Y
Every number in param area means the row of area.
Converting decimal to binary , All of 1 area is selected Rows and columns can get through itGet configuration of pir area

Return Code
Return Code	Return Information	Description
200	Operation succeeded.	Requesting succeeded.
10001	Parameters error.	Parameters are empty or the format is incorrect.
10002	accessToken exception or is expired.	Get accessToken again.
10005	appKey exception.	appKey is frozen.
20002	Device does not exist.	
20006	Network exception.	Check the device network status. Try later.
20007	Device offline.	Check the device online status.
20008	Device response overtime.	Too many operations. Try later.
20014	Illegal deviceSerial.	
20018	The user does not have this device.	Check whether the device belongs to the current account.
49999	Data exception.	Calling the API exception.
60020	Subscription failed.	Calling the API failed.
1.16 Set chime type

Function

This API is used to set device chime type .

Request Address

{areaDomain}/api/lapp/device/chime/set

Request Type

POST

Request Parameters

Parameter Name	Description	Type	Required
accessToken	String	Obtained access_token during assigning permission	Y
deviceSerial	String	Device serial No.	Y
channelNo	int	Channel No., no transmission means the device itself.	N
type	int	Device chime type , 1-mechanical , 2-electronic 3-none	Y
duration	int	The length of time that sth lasts or continues	Y
HTTP Request Message
POST /api/lapp/device/chime/set HTTP/1.1
Host: isgpopen.ezvizlife.com
Content-Type: application/x-www-form-urlencoded

accessToken=at.7jao9nxm84yxu7yw432mo40d9ewg4sgx-2rsq7g7pvj-11pgy9c-f3mvxd7vu&deviceSerial=C24899350&channelNo=1&type=3&duration=10000
Return Data
{
    "code": "200",
    "msg": "Operation succeeded"
}
Return Code
Return Code	Return Information	Description
200	Operation succeeded.	Requesting succeeded.
10001	Parameters error.	Parameters are empty or the format is incorrect.
10002	accessToken exception or is expired.	Get accessToken again.
10005	appKey exception.	appKey is frozen.
20002	Device does not exist.	
20006	Network exception.	Check the device network status. Try later.
20007	Device offline.	Check the device online status.
20008	Device response overtime.	Too many operations. Try later.
20014	Illegal deviceSerial.	
20018	The user does not have this device.	Check whether the device belongs to the current account.
49999	Data exception.	Calling the API exception.
60020	Subscription failed.	Calling the API failed.
1.17 Get chime type

Function

This API is used to get device chime type .

Request Address

{areaDomain}/api/lapp/device/chime/get

Request Type

POST

Request Parameters

Parameter Name	Description	Type	Required
accessToken	String	Obtained access_token during assigning permission	Y
deviceSerial	String	Device serial No.	Y
channelNo	int	Channel No., no transmission means the device itself.	N
HTTP Request Message
POST /api/lapp/camera/video/sound/set HTTP/1.1
Host: isgpopen.ezvizlife.com
Content-Type: application/x-www-form-urlencoded

accessToken=at.0v1ksxnqdu5lxc2fak3ctbiq0r3269y9&deviceSerial=596510666&channelNo=1
Return Data
{
    "data": {
        "deviceSerial": "C24899350",
        "channelNo": 1,
        "type": 3,
        "duration": 1000
    },
    "code": "200",
    "msg": "Operation succeeded"
}
Return Field
Parameter Name	Type	Description
devceSerial	String	Device serial No.
channelNo	int	Channel No.
type	int	Device chime type , 1-mechanical , 2-electronic 3-none
duration	int	The length of time that sth lasts or continues
Return Code
Return Code	Return Information	Description
200	Operation succeeded.	Requesting succeeded.
10001	Parameters error.	Parameters are empty or the format is incorrect.
10002	accessToken exception or is expired.	Get accessToken again.
10005	appKey exception.	appKey is frozen.
20002	Device does not exist.	
20006	Network exception.	Check the device network status. Try later.
20007	Device offline.	Check the device online status.
20008	Device response overtime.	Too many operations. Try later.
20014	Illegal deviceSerial.	
20018	The user does not have this device.	Check whether the device belongs to the current account.
49999	Data exception.	Calling the API exception.
60020	Subscription failed.	Calling the API failed.
1.18 Set infrared type

API Function
This API is used to set device infrared type

Request Address

{areaDomain}/api/lapp/device/infrared/switch/set

Request Type

POST

Request Parameters

Parameter Name	Type	Description	Required
accessToken	String	Obtained access_token during assigning permission	Y
deviceSerial	String	Device serial No.	Y
enable	int	Status:0-Disable, 1-Enable	Y
channelNo	int	Channel No., no transmission means the device itself.	N
HTTP Request Message
POST /api/lapp/device/infrared/switch/get HTTP/1.1
Host: isgpopen.ezvizlife.com
Content-Type: application/x-www-form-urlencoded
accessToken=at.b5ippaayadv7ggygbncw7olp3nq7b129-2vcdp4lsz9-17yuus8-upr63lmag&deviceSerial=C24899350&channelNo=1&enable=0
Return Data
{
    "code": "200",
    "msg": "Operation succeeded"
}
Return Field
Parameter Name	Type	Description
deviceSerial	String	Device serial No.
channelNo	String	Channel No.
enable	int	Status: 0-Disable, 1-Enable
Return Code
Returned Code	Returned Infromation	Description
200	Operation succeeded.	Requesting succeeded.
10001	Parameters error.	Parameters are empty or the format is incorrect.
10002	accessToken exception or is expired.	Get accessToken again.
10004	The user does not exist.	
10005	appKey exception.	appKey is frozen.
20002	Device does not exist.	
20014	Illegal deviceSerial.	
20018	The user does not have this device.	Check whether the device belongs to the current account.
49999	Data exception.	Calling the API exception.
1.19 Get Infrared Type

API Function

This API is used to get device infrared type

Request Address

{areaDomain}/api/lapp/device/infrared/switch/get

Request Type

POST

Request Parameters

Parameter Name	Type	Description	Required
accessToken	String	Obtained access_token during assigning permission	Y
deviceSerial	String	Device serial No.	Y
channelNo	int	Channel No., no transmission means the device itself.	N
HTTP Request Message
POST /api/lapp/device/infrared/switch/get HTTP/1.1
Host: isgpopen.ezvizlife.com
Content-Type: application/x-www-form-urlencoded
accessToken=at.9mqitppidgce4y8n54ranvyqc9fjtsrl&deviceSerial=596510888&enable=1&channelNo=1
Return Data
{
    "data": {
        "deviceSerial": "C24899350",
        "channelNo": 1,
        "enable": 0
    },
    "code": "200",
    "msg": "Operation succeeded"
}
Return Code
Returned Code	Returned Infromation	Description
200	Operation succeeded.	Requesting succeeded.
10001	Parameters error.	Parameters are empty or the format is incorrect.
10002	accessToken exception or is expired.	Get accessToken again.
10005	appKey exception.	appKey is frozen.
20002	Device does not exist.	
20006	Network exception.	Check the device network status. Try later.
20007	Device offline.	Check the device online status.
20008	Device response overtime.	Too many operations. Try later.
20014	Illegal deviceSerial.	
20018	The user does not have this device.	Check whether the device belongs to the current account.
20032	The channel does not exist.	The channel does not exist.
49999	Data exception.	API call exception
60020	This command is not supported.	The device does not support the people counting funcrion.
60022	Already the current status.	Already the current status.
1.20 Get device time zone

API Function

Query the basic information of the user device (including time zone)

Request Address

{areaDomain}/api/lapp/device/info

Request Type

POST

Request Parameters

Parameter name	Type	Description	Required
accessToken	String	access_token	Y
deviceSerial	Strring	Device serial number	Y
version	String	Interface version number, the parameter must be entered as: utc to get the device time zone	Y
http Request Message
 POST /api/lapp/device/info HTTP/1.1
 Host: https://isgpopen.ezvizlife.com
 Content-Type: application/x-www-form-urlencoded

 accessToken=at.8mozdi23c6gd3i3acx252ryl9nxdi7pc-9db2tvmfdx-0e8lbja-kqw6uutal&deviceSerial=Q00737271&version=utc
Return Data
 {
     "code": "200",
     "data": {
         "deviceSerial": "Q00737272",
         "deviceName": "A1S(Q00737272)",
         "model": "CS-A1S-32WE2G",
         "status": 1,
         "defence": 8,
         "isEncrypt": 0,
         "alarmSoundMode": 1,
         "offlineNotify": 0,
         "wifiSsid": "",
         "timeZone": "UTC+14:00"
     },
     "msg": "Operation succeeded"
 }
Return Field
Field Name	Type	Description
deviceSerial	String	Device serial number
deviceName	String	Device name
model	String	Device model, such as CS-C2S-21WPFR-WX
status	int	Online status: 0-Offline, 1-Online
defence	int	Protected device arming and disarming status: 0-sleep, 8-at home, 16-outing, ordinary IPC arming and disarming status: 0-disarmed, 1-armed
isEncrypt	int	Encrypt: 0-no encryption, 1-encryption
alarmSoundMode	int	Alarm sound mode: 0-short call, 1-long call, 2-mute
offlineNotify	int	Whether to notify the device goes offline: 0-not notify 1-notify
wifiSsid	String	wifi ssid (returned when version = utc)
timeZone	String	Time zone (returned when version = utc)
Return code
Return code	Returned message	Description
200	Operate successfully	Request successfully
10001	Parameter error	The parameter is empty or the format is incorrect
10002	Abnormal or expired AccessToken	re-access AccessToken
10005	Abnormal appKey	appKey is frozen
20002	Device does not exist	
20014	deviceSerial is illegal	
20018	The user does not own the device	Check if the device belongs to the current account
49999	Data exception	Interface call exception
50000	Service exception	System service exception
1.21 Get time zone list

API Function

Get a list of time zones

Request Address

{areaDomain}/api/lapp/timezone/list

Request Type

POST

Request Parameters

Parameter name	Type	Description	Required
language	String	Time zone language
can only be ENGLISH or SIMPCN, the default value is ENGLISH	N
Http Request Message
 POST /api/lapp/timezone/list HTTP/1.1
 Host: https://isgpopen.ezvizlife.com
Return Data
  {
      "code": "200",
      "data": [
          {
              "tzCode": "2",
              "tzValue": "UTC+14:00",
              "disPlayName": "(UTC+14:00) Kiritimati Island"
          },
          {
              "tzCode": "4",
              "tzValue": "UTC+13:00",
              "disPlayName": "(UTC+13:00) Samoa"
          },
          {
              "tzCode": "6",
              "tzValue": "UTC+13:00",
              "disPlayName": "(UTC+13:00) Nuku'alofa"
          },
          {
              "tzCode": "8",
              "tzValue": "UTC+12:00",
              "disPlayName": "(UTC+12:00) Fiji"
          },
          {
              "tzCode": "10",
              "tzValue": "UTC+12:00",
              "disPlayName": "(UTC+12:00) Auckland, Wellington"
          },
          {
              "tzCode": "12",
              "tzValue": "UTC+12:00",
              "disPlayName": "(UTC+12:00) Anadyr, Petropavlovsk-Kamchatsky (RTZ 11)"
          },
          {
              "tzCode": "14",
              "tzValue": "UTC+12:00",
              "disPlayName": "(UTC+12:00) Coordinated Universal Time+12"
          },
          {
              "tzCode": "16",
              "tzValue": "UTC+11:00",
              "disPlayName": "(UTC+11:00) Solomon Is., New Caledonia"
          },
          {
              "tzCode": "18",
              "tzValue": "UTC+11:00",
              "disPlayName": "(UTC+11:00) Chokurdakh (RTZ 10)"
          },
          {
              "tzCode": "20",
              "tzValue": "UTC+10:00",
              "disPlayName": "(UTC+10:00) Canberra, Melbourne, Sydney"
          },
          {
              "tzCode": "22",
              "tzValue": "UTC+10:00",
              "disPlayName": "(UTC+10:00) Brisbane"
          },
          {
              "tzCode": "24",
              "tzValue": "UTC+10:00",
              "disPlayName": "(UTC+10:00) Magadan"
          },
          {
              "tzCode": "26",
              "tzValue": "UTC+10:00",
              "disPlayName": "(UTC+10:00) Hobart"
          },
          {
              "tzCode": "28",
              "tzValue": "UTC+10:00",
              "disPlayName": "(UTC+10:00) Vladivostok, Magadan (RTZ 9)"
          },
          {
              "tzCode": "30",
              "tzValue": "UTC+10:00",
              "disPlayName": "(UTC+10:00) Guam, Port Moresby"
          },
          {
              "tzCode": "32",
              "tzValue": "UTC+09:30",
              "disPlayName": "(UTC+09:30) Darwin"
          },
          {
              "tzCode": "34",
              "tzValue": "UTC+09:30",
              "disPlayName": "(UTC+09:30) Adelaide"
          },
          {
              "tzCode": "36",
              "tzValue": "UTC+09:00",
              "disPlayName": "(UTC+09:00) Seoul"
          },
          {
              "tzCode": "38",
              "tzValue": "UTC+09:00",
              "disPlayName": "(UTC+09:00) Osaka, Sapporo, Tokyo"
          },
          {
              "tzCode": "40",
              "tzValue": "UTC+09:00",
              "disPlayName": "(UTC+09:00) Yakutsk (RTZ 8)"
          },
          {
              "tzCode": "42",
              "tzValue": "UTC+08:00",
              "disPlayName": "(UTC+08:00) Beijing, Chongqing, Hong Kong, Urumqi"
          },
          {
              "tzCode": "44",
              "tzValue": "UTC+08:00",
              "disPlayName": "(UTC+08:00) Irkutsk (RTZ 7)"
          },
          {
              "tzCode": "46",
              "tzValue": "UTC+08:00",
              "disPlayName": "(UTC+08:00) Kuala Lumpur, Singapore"
          },
          {
              "tzCode": "48",
              "tzValue": "UTC+08:00",
              "disPlayName": "(UTC+08:00) Taipei"
          },
          {
              "tzCode": "50",
              "tzValue": "UTC+08:00",
              "disPlayName": "(UTC+08:00) Ulaanbaatar"
          },
          {
              "tzCode": "52",
              "tzValue": "UTC+08:00",
              "disPlayName": "(UTC+08:00) Perth"
          },
          {
              "tzCode": "54",
              "tzValue": "UTC+07:00",
              "disPlayName": "(UTC+07:00) Krasnoyarsk (RTZ 6)"
          },
          {
              "tzCode": "56",
              "tzValue": "UTC+07:00",
              "disPlayName": "(UTC+07:00) Bangkok, Hanoi, Jakarta"
          },
          {
              "tzCode": "58",
              "tzValue": "UTC+06:30",
              "disPlayName": "(UTC+06:30) Yangon (Rangoon)"
          },
          {
              "tzCode": "60",
              "tzValue": "UTC+06:00",
              "disPlayName": "(UTC+06:00) Dhaka"
          },
          {
              "tzCode": "62",
              "tzValue": "UTC+06:00",
              "disPlayName": "(UTC+06:00) Astana"
          },
          {
              "tzCode": "64",
              "tzValue": "UTC+06:00",
              "disPlayName": "(UTC+06:00) Novosibirsk (RTZ 5)"
          },
          {
              "tzCode": "66",
              "tzValue": "UTC+05:45",
              "disPlayName": "(UTC+05:45) Kathmandu"
          },
          {
              "tzCode": "68",
              "tzValue": "UTC+05:30",
              "disPlayName": "(UTC+05:30) Chennai, Kolkata, Mumbai, New Delhi"
          },
          {
              "tzCode": "70",
              "tzValue": "UTC+05:30",
              "disPlayName": "(UTC+05:30) Sri Jayawardenepura"
          },
          {
              "tzCode": "72",
              "tzValue": "UTC+05:00",
              "disPlayName": "(UTC+05:00) Ekaterinburg (RTZ 4)"
          },
          {
              "tzCode": "74",
              "tzValue": "UTC+05:00",
              "disPlayName": "(UTC+05:00) Islamabad, Karachi"
          },
          {
              "tzCode": "76",
              "tzValue": "UTC+05:00",
              "disPlayName": "(UTC+05:00) Ashgabat, Tashkent"
          },
          {
              "tzCode": "78",
              "tzValue": "UTC+04:30",
              "disPlayName": "(UTC+04:30) Kabul"
          },
          {
              "tzCode": "80",
              "tzValue": "UTC+04:00",
              "disPlayName": "(UTC+04:00) Abu Dhabi, Muscat"
          },
          {
              "tzCode": "82",
              "tzValue": "UTC+04:00",
              "disPlayName": "(UTC+04:00) Baku"
          },
          {
              "tzCode": "84",
              "tzValue": "UTC+04:00",
              "disPlayName": "(UTC+04:00) Yerevan"
          },
          {
              "tzCode": "86",
              "tzValue": "UTC+04:00",
              "disPlayName": "(UTC+04:00) Tbilisi"
          },
          {
              "tzCode": "88",
              "tzValue": "UTC+04:00",
              "disPlayName": "(UTC+04:00) Port Louis"
          },
          {
              "tzCode": "90",
              "tzValue": "UTC+04:00",
              "disPlayName": "(UTC+04:00) Izhevsk, Samara (RTZ 3)"
          },
          {
              "tzCode": "92",
              "tzValue": "UTC+03:30",
              "disPlayName": "(UTC+03:30) Tehran"
          },
          {
              "tzCode": "94",
              "tzValue": "UTC+03:00",
              "disPlayName": "(UTC+03:00) Kuwait, Riyadh"
          },
          {
              "tzCode": "96",
              "tzValue": "UTC+03:00",
              "disPlayName": "(UTC+03:00) Baghdad"
          },
          {
              "tzCode": "98",
              "tzValue": "UTC+03:00",
              "disPlayName": "(UTC+03:00) Minsk"
          },
          {
              "tzCode": "100",
              "tzValue": "UTC+03:00",
              "disPlayName": "(UTC+03:00) Nairobi"
          },
          {
              "tzCode": "102",
              "tzValue": "UTC+03:00",
              "disPlayName": "(UTC+03:00) Moscow, St. Petersburg, Volgograd (RTZ 2)"
          },
          {
              "tzCode": "104",
              "tzValue": "UTC+02:00",
              "disPlayName": "(UTC+02:00) E. Europe"
          },
          {
              "tzCode": "106",
              "tzValue": "UTC+02:00",
              "disPlayName": "(UTC+02:00) Cairo"
          },
          {
              "tzCode": "108",
              "tzValue": "UTC+02:00",
              "disPlayName": "(UTC+02:00) Helsinki, Kyiv, Riga, Sofia, Tallinn, Vilnius"
          },
          {
              "tzCode": "110",
              "tzValue": "UTC+02:00",
              "disPlayName": "(UTC+02:00) Athens, Bucharest"
          },
          {
              "tzCode": "112",
              "tzValue": "UTC+02:00",
              "disPlayName": "(UTC+02:00) Jerusalem"
          },
          {
              "tzCode": "114",
              "tzValue": "UTC+02:00",
              "disPlayName": "(UTC+02:00) Amman"
          },
          {
              "tzCode": "116",
              "tzValue": "UTC+02:00",
              "disPlayName": "(UTC+02:00) Kaliningrad (RTZ 1)"
          },
          {
              "tzCode": "118",
              "tzValue": "UTC+02:00",
              "disPlayName": "(UTC+02:00) Tripoli"
          },
          {
              "tzCode": "120",
              "tzValue": "UTC+02:00",
              "disPlayName": "(UTC+02:00) Beirut"
          },
          {
              "tzCode": "122",
              "tzValue": "UTC+02:00",
              "disPlayName": "(UTC+02:00) Harare, Pretoria"
          },
          {
              "tzCode": "124",
              "tzValue": "UTC+02:00",
              "disPlayName": "(UTC+02:00) Damascus"
          },
          {
              "tzCode": "126",
              "tzValue": "UTC+02:00",
              "disPlayName": "(UTC+02:00) Istanbul"
          },
          {
              "tzCode": "128",
              "tzValue": "UTC+01:00",
              "disPlayName": "(UTC+01:00) Belgrade, Bratislava, Budapest, Ljubljana, Prague"
          },
          {
              "tzCode": "130",
              "tzValue": "UTC+01:00",
              "disPlayName": "(UTC+01:00) Sarajevo, Skopje, Warsaw, Zagreb"
          },
          {
              "tzCode": "132",
              "tzValue": "UTC+01:00",
              "disPlayName": "(UTC+01:00) Windhoek"
          },
          {
              "tzCode": "134",
              "tzValue": "UTC+01:00",
              "disPlayName": "(UTC+01:00) Brussels, Copenhagen, Madrid, Paris"
          },
          {
              "tzCode": "136",
              "tzValue": "UTC+01:00",
              "disPlayName": "(UTC+01:00) West Central Africa"
          },
          {
              "tzCode": "138",
              "tzValue": "UTC+01:00",
              "disPlayName": "(UTC+01:00) Amsterdam, Berlin, Bern, Rome, Stockholm, Vienna"
          },
          {
              "tzCode": "140",
              "tzValue": "UTC",
              "disPlayName": "(UTC) Dublin, Edinburgh, Lisbon, London"
          },
          {
              "tzCode": "142",
              "tzValue": "UTC",
              "disPlayName": "(UTC) Monrovia, Reykjavik"
          },
          {
              "tzCode": "144",
              "tzValue": "UTC",
              "disPlayName": "(UTC) Casablanca"
          },
          {
              "tzCode": "146",
              "tzValue": "UTC",
              "disPlayName": "(UTC) Coordinated Universal Time"
          },
          {
              "tzCode": "148",
              "tzValue": "UTC-01:00",
              "disPlayName": "(UTC-01:00) Azores"
          },
          {
              "tzCode": "150",
              "tzValue": "UTC-01:00",
              "disPlayName": "(UTC-01:00) Cabo Verde Is."
          },
          {
              "tzCode": "152",
              "tzValue": "UTC-02:00",
              "disPlayName": "(UTC-02:00) Coordinated Universal Time-02"
          },
          {
              "tzCode": "154",
              "tzValue": "UTC-03:00",
              "disPlayName": "(UTC-03:00) Buenos Aires"
          },
          {
              "tzCode": "156",
              "tzValue": "UTC-03:00",
              "disPlayName": "(UTC-03:00) Salvador"
          },
          {
              "tzCode": "158",
              "tzValue": "UTC-03:00",
              "disPlayName": "(UTC-03:00) Brasilia"
          },
          {
              "tzCode": "160",
              "tzValue": "UTC-03:00",
              "disPlayName": "(UTC-03:00) Greenland"
          },
          {
              "tzCode": "162",
              "tzValue": "UTC-03:00",
              "disPlayName": "(UTC-03:00) Montevideo"
          },
          {
              "tzCode": "164",
              "tzValue": "UTC-03:00",
              "disPlayName": "(UTC-03:00) Cayenne, Fortaleza"
          },
          {
              "tzCode": "166",
              "tzValue": "UTC-03:30",
              "disPlayName": "(UTC-03:30) Newfoundland"
          },
          {
              "tzCode": "168",
              "tzValue": "UTC-04:00",
              "disPlayName": "(UTC-04:00) Atlantic Time (Canada)"
          },
          {
              "tzCode": "170",
              "tzValue": "UTC-04:00",
              "disPlayName": "(UTC-04:00) Cuiaba"
          },
          {
              "tzCode": "172",
              "tzValue": "UTC-04:00",
              "disPlayName": "(UTC-04:00) Santiago"
          },
          {
              "tzCode": "174",
              "tzValue": "UTC-04:00",
              "disPlayName": "(UTC-04:00) Asuncion"
          },
          {
              "tzCode": "176",
              "tzValue": "UTC-04:00",
              "disPlayName": "(UTC-04:00) Georgetown, La Paz, Manaus, San Juan"
          },
          {
              "tzCode": "178",
              "tzValue": "UTC-04:30",
              "disPlayName": "(UTC-04:30) Caracas"
          },
          {
              "tzCode": "180",
              "tzValue": "UTC-05:00",
              "disPlayName": "(UTC-05:00) Eastern Time (US & Canada)"
          },
          {
              "tzCode": "182",
              "tzValue": "UTC-05:00",
              "disPlayName": "(UTC-05:00) Bogota, Lima, Quito, Rio Branco"
          },
          {
              "tzCode": "184",
              "tzValue": "UTC-05:00",
              "disPlayName": "(UTC-05:00) Indiana (East)"
          },
          {
              "tzCode": "186",
              "tzValue": "UTC-06:00",
              "disPlayName": "(UTC-06:00) Saskatchewan"
          },
          {
              "tzCode": "188",
              "tzValue": "UTC-06:00",
              "disPlayName": "(UTC-06:00) Central America"
          },
          {
              "tzCode": "190",
              "tzValue": "UTC-06:00",
              "disPlayName": "(UTC-06:00) Central Time (US & Canada)"
          },
          {
              "tzCode": "192",
              "tzValue": "UTC-06:00",
              "disPlayName": "(UTC-06:00) Guadalajara, Mexico City, Monterrey"
          },
          {
              "tzCode": "194",
              "tzValue": "UTC-07:00",
              "disPlayName": "(UTC-07:00) Mountain Time (US & Canada)"
          },
          {
              "tzCode": "196",
              "tzValue": "UTC-07:00",
              "disPlayName": "(UTC-07:00) Chihuahua, La Paz, Mazatlan"
          },
          {
              "tzCode": "198",
              "tzValue": "UTC-07:00",
              "disPlayName": "(UTC-07:00) Arizona"
          },
          {
              "tzCode": "200",
              "tzValue": "UTC-08:00",
              "disPlayName": "(UTC-08:00) Pacific Time (US & Canada)"
          },
          {
              "tzCode": "202",
              "tzValue": "UTC-08:00",
              "disPlayName": "(UTC-08:00) Baja California"
          },
          {
              "tzCode": "204",
              "tzValue": "UTC-09:00",
              "disPlayName": "(UTC-09:00) Alaska"
          },
          {
              "tzCode": "206",
              "tzValue": "UTC-10:00",
              "disPlayName": "(UTC-10:00) Hawaii"
          },
          {
              "tzCode": "208",
              "tzValue": "UTC-11:00",
              "disPlayName": "(UTC-11:00) Coordinated Universal Time-11"
          },
          {
              "tzCode": "210",
              "tzValue": "UTC-12:00",
              "disPlayName": "(UTC-12:00) International Date Line West"
          }
      ],
      "msg": "Operation succeeded"
  }
Return Field
Field Name	Type	描Description
tzCode	String	Time zone encoding (used when calling the set time interface)
tzValue	String	Time zone
disPlayName	String	Time zone's display name
Return Code
Return code	Return message	Description
200	operate successfully	Request successfully
10001	Parameter error	The parameter is empty or the format is incorrect
49999	Data exception	Interface call exception
1.22 Set device time zone

API Function

Set the time zone of the user's device

Request Address

{areaDomain}/api/lapp/device/timezone/set

Request Type

POST

Request Parameters

Parameter name	Type	Description	Required
accessToken	String	access_token obtained by the authorization process	Y
deviceSerial	Strring	Device serial number	Y
timezone	String	Time zone code, tzCode value obtained through the time zone list query interface	Y
timeFormat	int	time format \	
0: YYYY-MM-DD, 1: MM-DD-YYYY, 2: DD-MM-YYYY
daylightSaving	String	Whether to turn on daylight saving time 0-not open, 1-open	N
httpRequest Message
 POST /api/lapp/device/timezone/set HTTP/1.1
 Host: https://isgpopen.ezvizlife.com
 Content-Type: application/x-www-form-urlencoded

 accessToken=at.8mozdi23c6gd3i3acx252ryl9nxdi7pc-9db2tvmfdx-0e8lbja-kqw6uutal&deviceSerial=Q00737272&timezone=188&timeFormat=0
Return Data
 {
     "code": "200",
     "msg": "Operation succeeded"
 }
Return Code
Return code	Return message	Description
200	Operate successfully	Requested successfully
10001	Parameter error	The parameter is empty or the format is incorrect
10002	Abnormal or expired AccessToken	re-accessAccessToken
10005	Abnormal appKey	appKey is frozen
20002	Device does not exist	
20014	deviceSerial is illegal	
20018	The user does not own the device	Check if the device belongs to the current account
49999	Data exception	Interface call exception
50000	Service exception	System service exception
1.23 Get device capability

API Function

Query the capability set of user device

Request Address

{areaDomain}/api/lapp/device/capacity

Request Type

POST

Minimum permissions required for sub-account token requests

"Permission":"Get" "Resource":"cam:序列号"

Request Parameters

Parameter name	Type	Description	Required
accessToken	String	access_token obtained by the authorization process	Y
deviceSerial	Strring	Device serial number	Y
channelNo	String	Device channel number	N
http请求报文
 POST /api/lapp/device/capacity HTTP/1.1
 Host: https://isgpopen.ezvizlife.com
 Content-Type: application/x-www-form-urlencoded

 accessToken=at.8mozdi23c6gd3i3acx252ryl9nxdi7pc-9db2tvmfdx-0e8lbja-kqw6uutal&deviceSerial=Q00737272
Return Data
 {
     "code": "200",
     "data": {
         "ptz_left_right": "0",
         "ptz_top_bottom": "0",
         "support_add_del_detector": "1",
         "support_alarm_voice": "1",
         "support_alert_tone": "1",
         "support_anti_open": "1",
         "support_ap_allseries": "1",
         "support_ap_mode": "2",
         "support_auto_offline": "0",
         "support_battery_manage": "1",
         "support_channel_number": 0,
         "support_cloud": "0",
         "support_defence": "1",
         "support_defenceplan": "1",
         "support_device_rf_signal_report": "1",
         "support_devicelog": "1",
         "support_disk": "0",
         "support_encrypt": "0",
         "support_ipc_link": "1",
         "support_language": "FRENCH,SPANISH,RUSSIAN,KOREAN,ITALIAN,GERMAN,ENGLISH",
         "support_message": "0",
         "support_modify_detectorguard": "0,0,7,7,7,0,7,0,0,0",
         "support_modify_detectorname": "1",
         "support_privacy": "0",
         "support_protection_mode": "1",
         "support_ptz": "0",
         "support_related_device": "2",
         "support_remote_quiet": "1",
         "support_safe_mode_plan": "1",
         "support_sim_card": "1",
         "support_smart_wifi": "1",
         "support_sound_light_alarm": "1",
         "support_talk": "0",
         "support_timezone": "1",
         "support_unbind": "0",
         "support_upgrade": "1",
         "support_weixin": "1",
         "support_wifi": "3",
         "support_wifi_userId": "1",
         "video_quality_capacity": []
     },
     "msg": "Operation succeeded"
 }
Return Field

See [Device Capability Set Description] (# capacity_list) for details

Capabilities that are in the capability set specification but not in the return field are not supported by default

Return Code

Return code	Return message	Description
200	Operate successfully	Requested successfully
10001	Parameter error	The parameter is empty or the format is incorrect
10002	Abnormal or expired AccessToken	re-accessAccessToken
10005	Abnormal appKey	appKey is frozen
20002	Device does not exist	
20014	deviceSerial is illegal	
20018	The user does not own the device	Check if the device belongs to the current account
49999	Data exception	Interface call exception
50000	Service exception	System service exception
1.24 Get device language

API Function

Get the current language setting of the user device

Request Address

{areaDomain}/api/lapp/device/language/get

Request Type

POST

Minimum permissions required for sub-account token requests

"Permission":"Get" "Resource":"dev:serial number"

Request Parameters

Parameter name	Type	Description	Required
accessToken	String	access_token obtained by the authorization process	Y
deviceSerial	Strring	Device serial number	Y
Http Request Message
 POST /api/lapp/device/language/get HTTP/1.1
 Host: https://isgpopen.ezvizlife.com
 Content-Type: application/x-www-form-urlencoded

 accessToken=at.8mozdi23c6gd3i3acx252ryl9nxdi7pc-9db2tvmfdx-0e8lbja-kqw6uutal&deviceSerial=Q00737272
Return Data
 {
     "code": "200",
     "data": {
         "language": "ENGLISH"
     },
     "msg": "Operation succeeded"
 }
Return Field
Field Name	Type	Description
language	String	Device language
Return code
Return code	Return message	Description
200	Operate successfully	Requested successfully
10001	Parameter error	The parameter is empty or the format is incorrect
10002	Abnormal or expired AccessToken	re-accessAccessToken
10005	Abnormal appKey	appKey is frozen
20002	Device does not exist	
20014	deviceSerial is illegal	
20018	The user does not own the device	Check if the device belongs to the current account
49999	Data exception	Interface call exception
50000	Service exception	System service exception
1.25 Set device language

API Function

Set user device language

Request Address

{areaDomain}/api/lapp/device/language/set

Request Type

POST

Minimum permissions required for sub-account token requests

"Permission":"Config" "Resource":"dev:serial number"

Requested Parameters

Parameter name	Type	Description	Required
accessToken	String	access_token obtained by the authorization process	Y
deviceSerial	String	Device serial number	Y
language	String	The language to be set. The parameter value can be obtained from the field [support_language] return by [Get Device Capability Set] (#api_capacity)	Y
Http Request Message
 POST /api/lapp/device/language/set HTTP/1.1
 Host: https://isgpopen.ezvizlife.com
 Content-Type: application/x-www-form-urlencoded

 accessToken=at.8mozdi23c6gd3i3acx252ryl9nxdi7pc-9db2tvmfdx-0e8lbja-kqw6uutal&deviceSerial=Q00737272&language=GERMAN
Return Data
 {
     "code": "200",
     "msg": "Operation succeeded"
 }
Return Code
Return code	Return message	Description
200	Operate successfully	Requested successfully
10001	Parameter error	The parameter is empty or the format is incorrect
10002	Abnormal or expired AccessToken	re-accessAccessToken
10005	Abnormal appKey	appKey is frozen
20002	Device does not exist	
20006	Network anomaly	Check the device network status, try again later
20007	The device is not online	Check if the device is online
20008	Device response timed out	Operating too frequently, try again later
20014	deviceSerial is illegal	
20018	The user does not own the device	Check if the device belongs to the current account
49999	Data exception	Interface call exception
50000	Service exception	System service exception


Change the video encryption password

API Function

Change the video encryption password of the device (** The password changed after the device is reset is invalid **)

URL

{areaDomain}/api/lapp/device/password/update`

Request Type

POST

Request Parameters

Parameter	Type	Description	Required
accessToken	String	Obtained access_token during assigning permission	Y
deviceSerial	String	Device serial No.	Y
oldPassword	String	Old encryption password of the device	Y
newPassword	String	New encryption password of the device. The password can not contains more than 12 characters	
Y			
HTTP Request Message
POST /api/lapp/device/password/update HTTP/1.1
Host: open.ys7.com
Content-Type: application/x-www-form-urlencoded

accessToken=at.0v1ksxnqdu5lxc2fak3ctbiq0r3269y9&deviceSerial=596510666&oldPassword=AAAAAA&newPassword=BBBBBB
Return Data
{
    "code": "200",
    "msg": "Operating succeeded!"
}
Return Code
Return Code	Returned Infromation	Description
200	Operation succeeded.	Requesting succeeded.
10001	Parameters error.	Parameters are empty or the format is incorrect.
10002	accessToken exception or is expired.	Get accessToken again.
10005	appKey exception.	appKey is frozen.
20002	Device does not exist.	
20006	Network exception.	Check the device network status. Try later.
20007	Device offline.	Check the device online status.
20008	Device response timeout	The operation is too frequent. Try again later
20010	The device verification code is incorrect	Verify that the old password is correct
20014	deviceSerial is illegal	
20018	The user does not own the device	Check whether the device belongs to the current account
49999	data exception	API call exception
60012	unknown error	The device returns another error code
60020	This command is not supported	Check whether the device supports changing the video preview password


. API List

This section contains the APIs used for enabling or disabling device function status。

See the following list：

No.	Function	Description
1	Get device version	Get device version information
2	Upgrade device firmware	Upgrade device firmware
3	Get device upgrade status	Get device upgrade status, including upgrade progress, status and so on.
1.1 Get Device Version Information

API Function

Search the specified device version information.

Request Address

{areaDomain}/api/lapp/device/version/info

Request Type

POST

Request Parameters

Parameter Name	Type	Description	Required
accessToken	String	Obtained access_token during assigning permission	Y
deviceSerial	String	Device serial No.	Y
HTTP Request Message
POST /api/lapp/device/encrypt/off HTTP/1.1
Host: isgpopen.ezvizlife.com
Content-Type: application/x-www-form-urlencoded
accessToken=at.8z25h2063dapeus7c99bb0r6e0kjfjz5&deviceSerial=427734888&validateCode=ABCDEF
Return Data
{
    "data": {
        "latestVersion": "V4.2.5 build 151223",
        "currentVersion": "V4.2.5 build 151223"
    },
    "code": "200",
    "msg": "Operating succeeded!"
}
Return Field
Field Name	Type	Description
latestVersion	String	Latest version
currentVersion	String	Current version
Return Code
Return Code	Return Information	Description
200	Operating succeeded.	Request succeeded.
10001	Parameter error.	The parameter is empty or incorrect format.
10002	accessToken exception or expired.	Re-get the accessToken
10005	appKey exception	appKey is frozen.
20002	The device does not exist.	
20014	Illegal deviceSerial	
20018	Illegal deviceSerial	Chcek whether the device is belong to the current account.
49999	Data exception.	API call exception.
1.2 Upgrade Device Firmware

API Function

Upgrade device firmware to the latest version.

Request Address

{areaDomain}/api/lapp/device/upgrade

Request Type

POST

Request Parameters

Parameter Name	Type	Description	Required
accessToken	String	Obtained access_token during assigning permission	Y
deviceSerial	String	Device serial No.	Y
HTTP Request Message
POST /api/lapp/device/encrypt/off HTTP/1.1
Host: isgpopen.ezvizlife.com
Content-Type: application/x-www-form-urlencoded
accessToken=at.8z25h2063dapeus7c99bb0r6e0kjfjz5&deviceSerial=427734888&validateCode=ABCDEF
Return Data
{
    "code": "200",
    "msg": "Operating succeeded!"
}
Return Code
Return Code	Return Information	Description
200	Operating succeeded.	Request succeeded.
10001	Parameter error.	The parameter is empty or incorrect format.
10002	accessToken exception or expired.	Re-get the accessToken
10005	appKey exception	appKey is frozen.
20002	The device does not exist.	
20006	Network exception.	Check the device network status. Try later.
20007	Device offline.	Check the device online status.
20008	Device response overtime.	Too many operations. Try later.
20014	Illegal deviceSerial	
20018	No this device.	Chcek whether the device is belong to the current account.
49999	Data exception.	API call exception.
60013	Already the latest version.	
60014	Device is upgrading.	
60015	Device is rebooting	
60016	Device upgrade failed.	Check device network status.
1.3 Get Device Upgrade Status

API Function

Search the upgrade status, inclduing the upgrade progress of specified device。

Request Address

{areaDomain}/api/lapp/device/upgrade/status

Request Type

POST

Request Parameters

Parameter Name	Type	Description	Required
accessToken	String	Obtained access_token during assigning permission	Y
deviceSerial	String	Device serial No.	Y
HTTP Request Message
POST /api/lapp/device/encrypt/off HTTP/1.1
Host: isgpopen.ezvizlife.com
Content-Type: application/x-www-form-urlencoded
accessToken=at.8z25h2063dapeus7c99bb0r6e0kjfjz5&deviceSerial=427734888&validateCode=ABCDEF
Return Data
{
    "data": {
        "progress": 43,
        "status": 0
    },
    "code": "200",
    "msg": "Operating succeeded!"
}
Return Field
Field Name	Type	Description
progress	int	Upgrade progress,valid only in upgrading staus, ranging from 1 to 100
status	int	Upgrade status: 0-Upgrading, 1-Device reboot, 2-Upgraded, 3- Upgrading failed.
Return Code
Return Code	Return Information	Description
200	Operating succeeded.	Request succeeded.
10001	Parameter error.	The parameter is empty or incorrect format.
10002	accessToken exception or expired.	Re-get the accessToken
10005	appKey exception	appKey is frozen.
20002	The device does not exist.	
20007	Device offline	Check the device online status.
20014	Illegal deviceSerial	
20018	No this device.	Chcek whether the device is belong to the current account.
49999	Data exception.	API call exception.


1. API List

This section contains the APIs of PTZ control.

The API list is as the follows:

No.	Function	Description
1	Start PTZ control	Start PTZ
2	Stop PTZ control	Stop PTZ
3	Mirror Flip	Mirror flip
4	Add preset	Add preset
5	Call preset	Call preset
6	Clear preset	Clear preset
1.1 Start PTZ Control

API Function

Start the PTZ control. For other operations, including pan and tilt, call Stop PTZ Control API to stop the PTZ control first.

Request Address

{areaDomain}/api/lapp/device/ptz/start

Request Type

POST

Request Parameters

Parameter	Type	Description	Required
accessToken	String	The access_token during authentication.	Y
deviceSerial	String	The device serial No..	Y
channelNo	int	Channel No.	Y
direction	int	Operation Command: 0-Up, 1-Down, 2-Left, 3-Right, 4-Upper-left, 5-Lower-left, 6-Upper-right, 7-Lower-right, 8-Zoom in, 9-Zoom out, 10-Focus Near, 11-Focus Far	Y
speed	int	PTZ speed:0-Slow，1-Medium，2-Fast	Y
HTTP Request Message
POST /api/lapp/device/ptz/start HTTP/1.1
Host: isgpopen.ezvizlife.com
Content-Type: application/x-www-form-urlencoded
accessToken=at.4g01l53x0w22xbp30ov33q44app1ns9m&deviceSerial=502608888&channelNo=1&direction=2&speed=1
Return Data
{
    "code": "200",
    "msg": "Operating succeeded!"
}
Returned Code
Returned Code	Returned Message	Description
200	Operation succeeded.	Requesting succeeded.
10001	Parameters error.	Parameter is empty or the format is incorrect.
10002	accessToken exception or expired.	Get accessToken again.
10005	appKey exception.	appKey is frozen.
20002	Device does not exist.	
20006	Network exception.	Check the network status. Try again.
20007	The device is offline.	Check whether the device is online.
20008	Device requesting timeout.	No more operations. Try again.
20014	Network exception.	Check the network status. Try again.
20032	The channel does not exist in this user.	Check whether the device has this channel.
49999	Data exception.	Calling the API exception.
60000	The device does not support PTZ control	The device encryption is enabled.
60001	No PTZ control permission.	The device encryption is enabled.
60002	Device PTZ reached upper limit.	
60003	Device PTZ reached lower limit.	
60004	Device PTZ reached left limit.	
60005	Device PTZ reached right limit.	
60006	PTZ operation failed.	Try later.
60009	Calling the preset.	
60020	This command is not supported.	Confirm whether the device supports this operation.
1.2 Stop PTZ Control

API Function

The device stopped PTZ control

Request Address

{areaDomain}/api/lapp/device/ptz/stop

Request Type

POST

Request Parameters

Parameter	Type	Description	Required
accessToken	String	The access_token during authentication.	Y
deviceSerial	String	The device serial No..	Y
channelNo	int	Channel No.	Y
direction	int	Operation Command: 0-Up, 1-Down, 2-Left, 3-Right, 4-Upper-left, 5-Lower-left, 6-Upper-right, 7-Lower-right, 8-Zoom in, 9-Zoom out, 10-Focus Near, 11-Focus Far	Y
HTTP Request Message
POST /api/lapp/device/ptz/stop HTTP/1.1
Host: isgpopen.ezvizlife.com
Content-Type: application/x-www-form-urlencoded
accessToken=at.25ne3gkr6fa7coh34ys0fl1h9hryc2kr&deviceSerial=568261888&channelNo=1
Return Data
{
    "code": "200",
    "msg": "Operating succeeded!"
}
Returned Code
Returned Code	Returned Message	Description
200	Operation succeeded.	Requesting succeeded.
10001	Parameters error.	Parameter is empty or the format is incorrect.
10002	accessToken exception or expired.	Get accessToken again.
10005	appKey exception.	appKey is frozen.
20002	Device does not exist.	
20006	Network exception.	Check the network status. Try again.
20007	The device is offline.	Check whether the device is online.
20008	Device requesting timeout.	No more operations. Try again.
20014	Network exception.	Check the network status. Try again.
20032	The channel does not exist in this user.	Check whether the device has this channel.
49999	Data exception.	Calling the API exception.
60000	The device does not support PTZ control	The device encryption is enabled.
60001	No PTZ control permission.	The device encryption is enabled.
60006	PTZ operation failed.	Try later.
60009	Calling the preset.	
60020	This command is not supported.	Confirm whether the device supports this operation.
1.3 Mirror Filp

API Function:

Operate the mirror flip (should be supported by device).

Request Address:

{areaDomain}/api/lapp/device/ptz/mirror

Request Type

POST

Request Parameters

Parameter	Type	Description	Required
accessToken	String	The access_token during authentication.	Y
deviceSerial	String	The device serial No..	Y
channelNo	int	Channel No.	Y
command	int	Mirror direction:0-Up/Down, 1-Left/Right,2-Center	Y
HTTP Request Message
POST /api/lapp/device/ptz/mirror HTTP/1.1
Host: isgpopen.ezvizlife.com
Content-Type: application/x-www-form-urlencoded
accessToken=at.9mqitppidgce4y8n54ranvyqc9fjtsrl&deviceSerial=427734888&channelNo=1&command=2
Return Data
{
    "code": "200",
    "msg": "Operating succeeded!"
}
Returned Code
Returned Code	Returned Message	Description
200	Operation succeeded.	Requesting succeeded.
10001	Parameters error.	Parameter is empty or the format is incorrect.
10002	accessToken exception or expired.	Get accessToken again.
10005	appKey exception.	appKey is frozen.
20002	Device does not exist.	
20006	Network exception.	Check the network status. Try again.
20007	The device is offline.	Check whether the device is online.
20008	Device requesting timeout.	No more operations. Try again.
20014	Network exception.	Check the network status. Try again.
20032	The channel does not exist in this user.	Check whether the device has this channel.
49999	Data exception.	Calling the API exception.
60000	The device does not support PTZ control	The device encryption is enabled.
60001	No PTZ control permission.	The device encryption is enabled.
60006	PTZ operation failed.	Try later.
60009	Calling the preset.	
60020	This command is not supported.	Confirm whether the device supports this operation.
1.4 Add Preset

API Function:

Add preset (should be supported by device)

Request Address:

{areaDomain}/api/lapp/device/preset/add

Request Type

POST

Request Parameters

Parameter	Type	Description	Required
accessToken	String	The access_token during authentication.	Y
deviceSerial	String	The device serial No..	Y
channelNo	int	Channel No.	Y
HTTP Request Message
POST /api/lapp/device/preset/add HTTP/1.1
Host: isgpopen.ezvizlife.com
Content-Type: application/x-www-form-urlencoded
accessToken=at.25ne3gkr6fa7coh34ys0fl1h9hryc2kr&deviceSerial=568261888&channelNo=1
Return Data
{
    "data": {
        "index": 3
    },
    "code": "200",
    "msg": "Operating succeeded!"
}
Return Field
Field Name	Type	Description
index	int	Preset No.,for C6 device, the No.s is from 1 to 12.，This parameters should be saved by the developer.
Returned Code
Returned Code	Returned Message	Description
200	Operation succeeded.	Requesting succeeded.
10001	Parameters error.	Parameter is empty or the format is incorrect.
10002	accessToken exception or expired.	Get accessToken again.
10005	appKey exception.	appKey is frozen.
20002	Device does not exist.	
20006	Network exception.	Check the network status. Try again.
20007	The device is offline.	Check whether the device is online.
20008	Device requesting timeout.	No more operations. Try again.
20014	Network exception.	Check the network status. Try again.
20032	The channel does not exist in this user.	Check whether the device has this channel.
49999	Data exception.	Calling the API exception.
60000	The device does not support PTZ control	The device encryption is enabled.
60001	No PTZ control permission.	The device encryption is enabled.
60006	PTZ operation failed.	Try later.
60007	No more preset can be set.	
60008	No more C6 preset can be added.	The maximum C6 preset number is 12.
1.5 Call Preset

API Function:

Call the preset

Request Address:

{areaDomain}/api/lapp/device/preset/move

Request Type

POST

Request Parameters

Parameter	Type	Description	Required
accessToken	String	The access_token during authentication.	Y
deviceSerial	String	The device serial No..	Y
channelNo	int	Channel No.	Y
index	int	Preset, the preset No.s of C6 device is from 1 to 12.	Y
HTTP Request Message
POST /api/lapp/device/preset/move HTTP/1.1
Host: isgpopen.ezvizlife.com
Content-Type: application/x-www-form-urlencoded
accessToken=at.25ne3gkr6fa7coh34ys0fl1h9hryc2kr&deviceSerial=568261888&channelNo=1&index=3
Return Data
{
    "code": "200",
    "msg": "Operating succeeded!"
}
Returned Code
Returned Code	Returned Message	Description
200	Operation succeeded.	Requesting succeeded.
10001	Parameters error.	Parameter is empty or the format is incorrect.
10002	accessToken exception or expired.	Get accessToken again.
10005	appKey exception.	appKey is frozen.
20002	Device does not exist.	
20006	Network exception.	Check the network status. Try again.
20007	The device is offline.	Check whether the device is online.
20008	Device response overtime.	Too many operations. Try later.
20014	Illegal deviceSerial	
20018	No this device.	Chcek whether the device is belong to the current account.
20032	The channel does not exist.	The channel does not exist.
49999	Data exception.	API call exception.
60000	The device does not support PTZ control	The device encryption is enabled.
60001	No PTZ control permission.	The device encryption is enabled.
60006	The current PTZ operation failed.	Try later.
60009	Calling preset.	
60010	Preset called.	
60011	The presst does not exist.	
60020	This command is not supported.	Confirm whether the device supports this operation.
1.6 Clear Preset

API Function:

Clear preset

Request Address:

{areaDomain}/api/lapp/device/preset/clear

Request Type

POST

Request Parameters

Parameter	Type	Description	Required
accessToken	String	The access_token during authentication.	Y
deviceSerial	String	The device serial No..	Y
channelNo	int	Channel No.	Y
index	int	Preset, the preset No.s of C6 device is from 1 to 12.	Y
HTTP Request Message
POST /api/lapp/device/preset/clear HTTP/1.1
Host: isgpopen.ezvizlife.com
Content-Type: application/x-www-form-urlencoded
accessToken=at.25ne3gkr6fa7coh34ys0fl1h9hryc2kr&deviceSerial=568261888&channelNo=1&index=3
Return Data
{
    "code": "200",
    "msg": "Operating succeeded!"
}
Returned Code
Returned Code	Returned Message	Description
200	Operation succeeded.	Requesting succeeded.
10001	Parameters error.	Parameter is empty or the format is incorrect.
10002	accessToken exception or expired.	Get accessToken again.
10005	appKey exception.	appKey is frozen.
20002	Device does not exist.	
20006	Network exception.	Check the network status. Try again.
20007	The device is offline.	Check whether the device is online.
20008	Device response overtime.	Too many operations. Try later.
20014	Illegal deviceSerial	
20018	No this device.	Chcek whether the device is belong to the current account.
20032	The channel does not exist.	The channel does not exist.
49999	Data exception.	API call exception.
60000	The device does not support PTZ control	The device encryption is enabled.
60001	No PTZ control permission.	The device encryption is enabled.
60006	The current PTZ operation failed.	Try later.
60020	This command is not supported.	Confirm whether the device supports this operation.


1. API List

This section contains the APIs used for searching device alarm information.

API List:

No.	Function	Description
1	Get All Alarm Lists	Search all the alarm information lists in the current user.
2	Get Alarm List according to Device	Search the alarm list of the specified device.
1.1 Get All Alarm Lists

Function：

Get all the alarm information lists in the current account.

Request Address

{areaDomain}/api/lapp/alarm/list

Request Method

POST

Request Parameters

Parameters	Type	Description	Required
accessToken	String	The access_token obtained during authentication	Y
startTime	long	Alarm search start time. The time format is 1457420564508, exactly on the second.By default, it starts at 0 on current day, and only data within 7 days can be searched	N
endTime	long	Alarm search end time. The time format is 1457420564508, exactly on the second.By default, it ends at the current time.	N
alarmType	int	Alarm type,by default, it is -1 (All)	N
status	int	Alarm infromation status:2-All, 1- Read, 0- Unread, by default, it is 0 (Unread status)	N
pageStart	int	Start page for paging,start with 0 and the default value is 0.	N
pageSize	int	Page size,the default value is 10 and the maximum is 50.	N
Alarm Type:

-1: All
10000:PIR Event
10001:Emergency Button Event
10002:Motion Detection Alarm
10003:Baby Cry Alarm
10004:Magnetic Contact Alarm
10005:Smoke Alarm
10006:Combustible Gas Alarm
10008:Water Leak Alarm
10009:Emergency Button Alarm
10010:PIR Alarm
10011:Video Tempering Alarm
10012:Video Loss
10013:Line Crossing
10014:Intrusion
10015:Face Detection Event
40001:Third-party Capture
40002:Connectivity
10016:Door Bell Ring Alarm
10018:Curtain Alarm
10019:Open-close Detector Alarm
10020:Scene Change Detection
10021:Defocus Detection
10022:Audio Exception Detection
10023:Unattended Baggage Detection
10024:Object Removal Detection
10025:Illegal Parking Detection
10026:People Gathering Detection
10027:Lotering Detection
10028:Fast Moving Detection
10029:Region Entrance Detection
10030:Region Exiting Detection
10031:Magnetic Disturbance Alarm
10032:Low Batter Alarm
10033:Intrusion Alarm
10035:Baby Motion Detection
10036:Switch Power Supply Alarm
10100:IO Alarm
10101:IO-1 Alarm
10102:IO-2 Alarm
10103:IO-3 Alarm
10104:IO-4 Alarm
10105:IO-5 Alarm
10106:IO-6 Alarm
10107:IO-7 Alarm
10108:IO-8 Alarm
10109:IO-9 Alarm
10110:IO-10 Alarm
10111:IO-11 Alarm
10112:IO-12 Alarm
10113:IO-13 Alarm
10114:IO-14Alarm
10115:IO-15 Alarm
10116:IO-16 Alarm
12000:Motion Detection Alarm
12001:Video Loss
12002:Video Tampering Alarm
12003:Instant Zone Alarm
12004:Instant Zone Alarm Recovered
12005:24-hour Voiced Zone Alarm
12006:24-hour Voiced Zone Alarm Recovered
12007:Delay Zone Alarm
12008:Delay Zone Alarm Recovered
12009:Internal Delayed Alarm
12010:Internal Delayed Alarm Recovered
12011:Fire Alarm Arming Zone Alarm
12012:Fire Alarm Arming Zone Alarm Recovered
12013:Behavior Analysis Alarm
12014:Behavior Analysis Alarm Recovered
12015:24 Hour Non-voiced Zone Alarm
12016:24 Hour Non-voiced Zone Alarm Recovered
12017:24 Hour Aux Zone Alarm
12018:24 Hour Aux Zone Alarm Recovered
12019:24 Hour Shock Zone Alarm
12020:24 Hour Shock Zone Alarm Recovered
12021:Sensor Tampered
12022:Sensor Tamper Recovered
12023:Soft Zone Emergency Alarm
12024:Soft Zone Fire Alarm
12025:Soft Zone Bandit Alarm
12026:Duress Report
12027:Device Tampering Alarm
12028:Device Tampering Alarm Recovered
12029:AC Power Off
12030:AC Power On
12031:Low Battery Voltage
12032:Battery Voltage Recovery
12033:Telephone Disconnected
12034:Telephone Connected
12035:Expansion Bus Module Offline
12036:Expansion Bus Module Online
12037:Keyboard Offline.
12038:Keyboard Recovered
12039:KBUS Trigger Disconnection
12040:KBUS Trigger Recovered
12041:Auto Arming/Disarming Failed
12042:Auto Disarming Failed
12043:Wireless Network Exception
12044:Wireless Network Recovery
12045:SIM Card Exception
12046:SIM Card Recovery
12047:Control Panel Reset
12048:Disarm
12049:Arm
12050:Auto Disarm
12051:Auto Arm
12052:Clear Alarm
12053:Instant Arm
12054:Key Region Disarming
12055:Key Region Arming
12056:Stay Arm
12057:Forced Arm
12058:Bypass
12059:Bypass Recovery
12060:Partition Group Bypass
12061:Partition Group Bypass Recovered
12062:Manual Test Report
12063:Scheduled Test Report
12064:Single-Zone Disarming
12065:Single-Zone Arming
12066:Keypad Locked
12067:Keypad Unlocked
12068:Printer Disconnected
12069:Printer Connected
12070:Instant Disarming
12071:Stay Disarming
12072:Scheduled to Enable the Trigger
12073:Scheduled to Disable the Trigger
12074:Failed to enable the trigger according to the schedule.
12075:Failed to disable the trigger according to the schedule.
12076:Enter Programming
12077:Exit Programming
12078:KBUS GP/K Disconnection
12079:KBUS GP/K Connection
12080:KBUS MN/K Disconnection
12081:KBUS MN/K Connected
12082:IP Conflicted
12083:Normal IP
12084:Network Disconnected
12085:Normal Network
12086:Motion Detection Alarm Stopped
12087:Video Tampering Detection Stopped
12088:Video Signal Recovered
12089:Input/Output Video Standard Mismatch
12090:Input/Output Video Format Recovered
12091:Video Input Exception
12092:Video Input Recovered
12093:HDD Full
12094:Free HDD
12095:HDD Error
12096:HDD Recovered
12097:Uploading Picture Failed
12098:Detector Offline
12099:Detector Online
12100:Detector Battery Low
12101:Detector Battery OK
12102:Zone Add Detector
12103:Zone Delete Detector
12104:Wi-Fi Exception
:Wi-Fi Recovered
12106:RF Exception
12107:RF Recovered
10037:Over_Temperature Alarm
10038:Low_Temperature Alarm
10039:Over_Humidity Alarm
10040:Low_Humidity Alarm
12108:Host Anti-tamper Alarm
12109:Host Anti-tamper Alarm Recovered
12110:Card Reader Anti-Tamper Alarm
12111:Card Reader Anti-Tamper Alarm Recovered
12112:Event Input Alarm
12113:Event Input Alarm Recovery
12114:Door Control Security Anti-Tamper Alarm
12115:Door Control Security Anti-Tamper Alarm Recovered
12116:Network Disconnected
12117:Network Connected
12118:Device Power On
12119:Device Power Off
12120:Door Abnormally Open
HTTP Request Message
POST /api/lapp/alarm/list HTTP/1.1
Host: isgpopen.ezvizlife.com
Content-Type: application/x-www-form-urlencoded
accessToken=at.47egoa5iazk02hcn73sepv2q12x8ulsx&startTime=&endTime=&alarmType=-1&status=2&pageStart=0&pageSize=3
Return Data
{
    "page":{
        "total":9,
        "page":0,
        "size":3
    },
    "data":[
        {
            "alarmId":"24027912025633491",
            "alarmName":"Device 1",
            "alarmType":10000,
            "alarmTime":4364654646485,
            "channelNo":1,
            "isEncrypt":0,
            "isChecked":0,
            "preTime":10,
            "delayTime":30,
            "deviceSerial":"427734888",
            "alarmPicUrl":"https://wuhancloudpictest.ys7.com:8083/HIK_1455866402_724A2B55F5AFe741_06CE56000475452014644?isEncrypted=0&isCloudStored=0",
            "relationAlarms":[
            ],
            "customerType":null,
            "customerInfo":null
        },
        {
            "alarmId":"24027912025633469",
            "alarmName":"Device 2",
            "alarmType":10000,
            "alarmTime":4364654646485,
            "channelNo":1,
            "isEncrypt":0,
            "isChecked":0,
            "preTime":10,
            "delayTime":30,
            "deviceSerial":"427734777",
            "alarmPicUrl":"https://wuhancloudpictest.ys7.com:8083/HIK_1455865753_B2B20A0FB4B45da2_06CE56000475437014644?isEncrypted=0&isCloudStored=0",
            "relationAlarms":[
            ],
            "customerType":null,
            "customerInfo":null
        },
        {
            "alarmId":"24027912025633457",
            "alarmName":"Device 3",
            "alarmType":10000,
            "alarmTime":4364654646485,
            "channelNo":1,
            "isEncrypt":0,
            "isChecked":0,
            "preTime":10,
            "delayTime":30,
            "deviceSerial":"427734666",
            "alarmPicUrl":"https://wuhancloudpictest.ys7.com:8083/HIK_1455865563_0C0F2D84B18Ead68_06CE56000475431014644?isEncrypted=0&isCloudStored=0",
            "relationAlarms":[
            ],
            "customerType":null,
            "customerInfo":null
        }
    ],
    "code":"200",
    "msg":"Operation succeeded!"
}
Return Filed：
Filed Name	Type	Description
alarmId	String	Aalrm Information ID
alarmName	String	Alarm source name
alarmType	int	Alarm type
alarmTime	long	Alarm time. The format is 2323452345, exactly on the millisecond
channelNo	int	Channel No.
isEncrypt	int	Encrypt?：0-No，1-Yes
isChecked	int	Read?0- No, 1- Yes
preTime	int	Pre-record time (s)
delayTime	int	Post-record time(s)
deviceSerial	String	Device serial No.
alarmPicUrl	String	Alarm picture address
relationAlarms	list	Linked alarm information
customerType	String	String Transparent Device Parameter Type
customerInfo	String	String Transparent Device Parameter Content
Return Code
Returned Code	Returned Infromation	Description
200	Operation succeeded.	Requesting succeeded.
10001	Parameters error.	Parameters are empty or the format is incorrect.
10002	accessToken exception or is expired.	Get accessToken again.
10005	appKey exception.	appKey is frozen.
49999	Data exception.	Calling the API exception.
1.2Get Alarm Information List by Device

Function

Get the device corresponding alarm information list.

Request Address

{areaDomain}/api/lapp/alarm/device/list

Request Method

POST

Request Parameters

Parameter	Type	Description	Required
accessToken	String	The access_token during authentication.	Y
deviceSerial	String	The device serial No..	Y
pageSize	int	Page size, the default value is 10 and the maximum is 50.	N
pageStart	int	Start page for paging, start with 0 and the default value is 0.	N
startTime	long	Alarm search start time. The time format is 1457420564508, exactly on the second. By default, it starts at 0 on current day, and only data within 7 days can be searched.	N
endTime	long	Alarm search end time. The time format is 1457420564508, exactly on the second. By default, it ends at the current time.	N
status	int	Alarm Information Status:2-All, 1- Read, 0- Unread, by default, it is 0 (Unread status)	N
alarmType	int	Alarm type,by default, it is -1 (All)	N
Alarm Type:

-1: All
10000:PIR Event
10001:Emergency Button Event
10002:Motion Detection Alarm
10003:Baby Cry Alarm
10004:Magnetic Contact Alarm
10005:Smoke Alarm
10006:Combustible Gas Alarm
10008:Water Leak Alarm
10009:Emergency Button Alarm
10010:PIR Alarm
10011:Video Tempering Alarm
10012:Video Loss
10013:Line Crossing
10014:Intrusion
10015:Face Detection Event
40001:Third-party Capture
40002:Connectivity
10016:Door Bell Ring Alarm
10018:Curtain Alarm
10019:Open-close Detector Alarm
10020:Scene Change Detection
10021:Defocus Detection
10022:Audio Exception Detection
10023:Unattended Baggage Detection
10024:Object Removal Detection
10025:Illegal Parking Detection
10026:People Gathering Detection
10027:Lotering Detection
10028:Fast Moving Detection
10029:Region Entrance Detection
10030:Region Exiting Detection
10031:Magnetic Disturbance Alarm
10032:Low Batter Alarm
10033:Intrusion Alarm
10035:Baby Motion Detection
10036:Switch Power Supply Alarm
10100:IO Alarm
10101:IO-1 Alarm
10102:IO-2 Alarm
10103:IO-3 Alarm
10104:IO-4 Alarm
10105:IO-5 Alarm
10106:IO-6 Alarm
10107:IO-7 Alarm
10108:IO-8 Alarm
10109:IO-9 Alarm
10110:IO-10 Alarm
10111:IO-11 Alarm
10112:IO-12 Alarm
10113:IO-13 Alarm
10114:IO-14Alarm
10115:IO-15 Alarm
10116:IO-16 Alarm
12000:Motion Detection Alarm
12001:Video Loss
12002:Video Tampering Alarm
12003:Instant Zone Alarm
12004:Instant Zone Alarm Recovered
12005:24-hour Voiced Zone Alarm
12006:24-hour Voiced Zone Alarm Recovered
12007:Delay Zone Alarm
12008:Delay Zone Alarm Recovered
12009:Internal Delayed Alarm
12010:Internal Delayed Alarm Recovered
12011:Fire Alarm Arming Zone Alarm
12012:Fire Alarm Arming Zone Alarm Recovered
12013:Behavior Analysis Alarm
12014:Behavior Analysis Alarm Recovered
12015:24 Hour Non-voiced Zone Alarm
12016:24 Hour Non-voiced Zone Alarm Recovered
12017:24 Hour Aux Zone Alarm
12018:24 Hour Aux Zone Alarm Recovered
12019:24 Hour Shock Zone Alarm
12020:24 Hour Shock Zone Alarm Recovered
12021:Sensor Tampered
12022:Sensor Tamper Recovered
12023:Soft Zone Emergency Alarm
12024:Soft Zone Fire Alarm
12025:Soft Zone Bandit Alarm
12026:Duress Report
12027:Device Tampering Alarm
12028:Device Tampering Alarm Recovered
12029:AC Power Off
12030:AC Power On
12031:Low Battery Voltage
12032:Battery Voltage Recovery
12033:Telephone Disconnected
12034:Telephone Connected
12035:Expansion Bus Module Offline
12036:Expansion Bus Module Online
12037:Keyboard Offline.
12038:Keyboard Recovered
12039:KBUS Trigger Disconnection
12040:KBUS Trigger Recovered
12041:Auto Arming/Disarming Failed
12042:Auto Disarming Failed
12043:Wireless Network Exception
12044:Wireless Network Recovery
12045:SIM Card Exception
12046:SIM Card Recovery
12047:Control Panel Reset
12048:Disarm
12049:Arm
12050:Auto Disarm
12051:Auto Arm
12052:Clear Alarm
12053:Instant Arm
12054:Key Region Disarming
12055:Key Region Arming
12056:Stay Arm
12057:Forced Arm
12058:Bypass
12059:Bypass Recovery
12060:Partition Group Bypass
12061:Partition Group Bypass Recovered
12062:Manual Test Report
12063:Scheduled Test Report
12064:Single-Zone Disarming
12065:Single-Zone Arming
12066:Keypad Locked
12067:Keypad Unlocked
12068:Printer Disconnected
12069:Printer Connected
12070:Instant Disarming
12071:Stay Disarming
12072:Scheduled to Enable the Trigger
12073:Scheduled to Disable the Trigger
12074:Failed to enable the trigger according to the schedule.
12075:Failed to disable the trigger according to the schedule.
12076:Enter Programming
12077:Exit Programming
12078:KBUS GP/K Disconnection
12079:KBUS GP/K Connection
12080:KBUS MN/K Disconnection
12081:KBUS MN/K Connected
12082:IP Conflicted
12083:Normal IP
12084:Network Disconnected
12085:Normal Network
12086:Motion Detection Alarm Stopped
12087:Video Tampering Detection Stopped
12088:Video Signal Recovered
12089:Input/Output Video Standard Mismatch
12090:Input/Output Video Format Recovered
12091:Video Input Exception
12092:Video Input Recovered
12093:HDD Full
12094:Free HDD
12095:HDD Error
12096:HDD Recovered
12097:Uploading Picture Failed
12098:Detector Offline
12099:Detector Online
12100:Detector Battery Low
12101:Detector Battery OK
12102:Zone Add Detector
12103:Zone Delete Detector
12104:Wi-Fi Exception
:Wi-Fi Recovered
12106:RF Exception
12107:RF Recovered
10037:Over_Temperature Alarm
10038:Low_Temperature Alarm
10039:Over_Humidity Alarm
10040:Low_Humidity Alarm
12108:Host Anti-tamper Alarm
12109:Host Anti-tamper Alarm Recovered
12110:Card Reader Anti-Tamper Alarm
12111:Card Reader Anti-Tamper Alarm Recovered
12112:Event Input Alarm
12113:Event Input Alarm Recovery
12114:Door Control Security Anti-Tamper Alarm
12115:Door Control Security Anti-Tamper Alarm Recovered
12116:Network Disconnected
12117:Network Connected
12118:Device Power On
12119:Device Power Off
12120:Door Abnormally Open
HTTP Request Report
POST /api/lapp/alarm/list HTTP/1.1
Host: isgpopen.ezvizlife.com
Content-Type: application/x-www-form-urlencoded
accessToken=at.47egoa5iazk02hcn73sepv2q12x8ulsx&deviceSerial=427734888&startTime=&endTime=&alarmType=-1&status=2&pageStart=0&pageSize=3
Return Data
{
    "page":{
        "total":9,
        "page":0,
        "size":3
    },
    "data":[
        {
            "alarmId":"24027912025633491",
            "alarmName":"Device 1",
            "alarmType":10000,
            "alarmTime":4364654646485,
            "channelNo":1,
            "isEncrypt":0,
            "isChecked":0,
            "preTime":10,
            "delayTime":30,
            "deviceSerial":"427734888",
            "alarmPicUrl":"https://wuhancloudpictest.ys7.com:8083/HIK_1455866402_724A2B55F5AFe741_06CE56000475452014644?isEncrypted=0&isCloudStored=0",
            "relationAlarms":[
            ],
            "customerType":null,
            "customerInfo":null
        },
        {
            "alarmId":"24027912025633469",
            "alarmName":"Device 1",
            "alarmType":10000,
            "alarmTime":4364654646485,
            "channelNo":1,
            "isEncrypt":0,
            "isChecked":0,
            "preTime":10,
            "delayTime":30,
            "deviceSerial":"427734888",
            "alarmPicUrl":"https://wuhancloudpictest.ys7.com:8083/HIK_1455865753_B2B20A0FB4B45da2_06CE56000475437014644?isEncrypted=0&isCloudStored=0",
            "relationAlarms":[
            ],
            "customerType":null,
            "customerInfo":null
        },
        {
            "alarmId":"24027912025633457",
            "alarmName":"Device 1",
            "alarmType":10000,
            "alarmTime":4364654646485,
            "channelNo":1,
            "isEncrypt":0,
            "isChecked":0,
            "preTime":10,
            "delayTime":30,
            "deviceSerial":"427734888",
            "alarmPicUrl":"https://wuhancloudpictest.ys7.com:8083/HIK_1455865563_0C0F2D84B18Ead68_06CE56000475431014644?isEncrypted=0&isCloudStored=0",
            "relationAlarms":[
            ],
            "customerType":null,
            "customerInfo":null
        }
    ],
    "code":"200",
    "msg":"Operation succeeded!"
}
Return Filed
Filed Name	Type	Description
alarmId	String	Aalrm Information ID
alarmName	String	Alarm source name
alarmType	int	Alarm type
alarmTime	long	Alarm time. The format is 2323452345, exactly on the millisecond
channelNo	int	Channel No.
isEncrypt	int	Encrypt?：0-No，1-Yes
isChecked	int	Read?0- No, 1- Yes
preTime	int	Pre-record time (s)
delayTime	int	Post-record time(s)
deviceSerial	String	Device serial No.
alarmPicUrl	String	Alarm picture address
relationAlarms	list	Linked alarm information
customerType	String	String Transparent Device Parameter Type
customerInfo	String	String Transparent Device Parameter Content
Return Code
Returned Code	Returned Infromation	Description
200	Operation succeeded.	Requesting succeeded.
10001	Parameters error.	Parameters are empty or the format is incorrect.
10002	accessToken exception or is expired.	Get accessToken again.
10005	appKey exception.	appKey is frozen.
20002	Device does not exist.	
20014	Illegal deviceSerial.	
20018	The user does not have this device.	Check whether the device belongs to the current account.
49999	Data exception.	Calling the API exception.


1. API List

This section introduces the APIs of A1 series device linked detector.

API List:

No.	Function	Description
1	Get Detector List	Search the A1 series device linked detector list.
2	Set Detector Status	Set the detector arming or disarming status.
3	Delete Detector	Delete the A1 series device linked detector.
4	Get IPC List to be Linked	Get IPC list which can be linked to A1 series device.
5	Get Linked IPC List	Get A1 series device linked IPC list.
6	Set the Linkage Relation between Detector and IPC	Set the Linkage Relation between A1 series device linked detector and IPC.
7	Edit Detector Name	Edit the detector name.
8	One-touch Clear Alarm for Device	The device clears the alarm remotely
9	Set device associated with detector	Set device associated with detector
1.1 Get Detector List

Function
This API is used to get A1 series device linked detector list.

Request Address

{areaDomain}/api/lapp/detector/list

Request Method

POST

Request Parameters

Parameter	Type	Description	Required
accessToken	String	The access_token during authentication.	Y
deviceSerial	String	The device serial No..	Y
HTTP Request Message
POST /api/lapp/detector/list HTTP/1.1
Host: isgpopen.ezvizlife.com
Content-Type: application/x-www-form-urlencoded
accessToken=at.9mqitppidgce4y8n54ranvyqc9fjtsrl&deviceSerial=596510888
Returned Data
{
     "result": {
         "data": [
             {
                 "detectorSerial": "594012222",
                 "detectorType": "callhelp",
                 "detectorState": 1,
                 "detectorTypeName": "Emergency Button,
                 "location": "Emergency Button",
                 "zfStatus": 0,
                 "uvStatus": 0,
                 "iwcStatus": 0,
                 "olStatus": 0,
                 "atHomeEnable": 1,
                 "outerEnable": 1,
                 "sleepEnable": 1,
                 "updateTime": "2017-09-01 15:30:45"
             },
             {
                 "detectorSerial": "303333333",
                 "detectorType": "waterlogging",
                 "detectorState": 1,
                 "detectorTypeName": "waterlogging",
                 "location": "Washing Room",
                 "zfStatus": 0,
                 "uvStatus": 0,
                 "iwcStatus": 0,
                 "olStatus": 1,
                 "atHomeEnable": 1,
                 "outerEnable": 1,
                 "sleepEnable": 1,
                 "updateTime": "2017-09-01 15:30:45"
             }
         ],
         "code": "200",
         "msg": "Operation succeeded!"
     }
}
Returned Filed
Field	Type	Description
detectorSerial	String	Detector No.
detectorType	String	Detector Type
detectorState	int	Whether the device connects to A1:0-No, 1-Yes
detectorTypeName	String	Detector Type Name
location	String	Detector Location (Custom), which is corresponding to the edited name.
zfStatus	int	Zone fault: 0- recover, 1- alarm
uvStatus	int	Battery undervoltage:0- recover, 1-alarm
iwcStatus	int	Wireless Interference:0- recover, 1- alarm
olStatus	int	Offline:0-recover, 1- alarm
atHomeEnable	int	Enable stay mode:0- disable, 1-enable
outerEnable	int	Enable away mode:0-disable, 1-enable
sleepEnable	int	Enable sleeping mode:0-disable, 1-enable
The fault type has zone fault, battery undervoltage, wireless interference, and offline. "Alarm" means the fault generates, "Recovery" means fault recovery.

Detector Type Name:

Detector Type	Detector Type Name
V	Video Device
I	Alarm-in Device
O	Alarm-out Device
PIR	IR Detector
FIRE	Smoke Detector
MAGNETOMETER	Magnetic Contact
GAS	Combustible Gas
WATERLOGGING	Water Leak
CALLHELP	Emergency Button
TELECONTROL	Remote Control
ALERTOR	Alarm Device
KEYBOARD	Keyboard
CURTAIN	Curtain
MOVE_MAGNETOMETER	Open-close Detector
Returned Code
Returned Code	Returned Message	Description
200	Operation succeeded.	Requesting succeeded.
10001	Parameters error.	Parameter is empty or the format is incorrect.
10002	accessToken exception or expired.	Get accessToken again.
10005	appKey exception.	appKey is frozen.
20002	Device does not exist.	
20014	Network exception.	Check the network status. Try again.
20018	The user does not have this device.	Check whether the device belongs to the current account.
49999	Data exception.	Calling the API exception.
1.2 Set Detector Status

Function
The API is used to set the arming/disarming status for the detector which is linked to A1 series device, including stay, away and sleeping.

Request Address

{areaDomain}/api/lapp/detector/status/set

Request Method

POST

Request Parameters

Parameter	Type	Description	Required
accessToken	String	The access_token during authentication.	Y
deviceSerial	String	The device serial No..	Y
detectorSerial	String	Detector No.	Y
safeMode	int	Security mode:0- stay, 1-away, 2-sleeping	Y
enable	int	Status:0-disabled, 1-enabled	Y
HTTP Request Message
POST /api/lapp/detector/status/set HTTP/1.1
Host: isgpopen.ezvizlife.com
Content-Type: application/x-www-form-urlencoded
accessToken=at.9mqitppidgce4y8n54ranvyqc9fjtsrl&deviceSerial=569262222&detectorSerial=604216666&enable=1&safeMode=2
Returned Data
{
    "code": "200",
    "msg": "Operation succeeded!"
}
Returned Code
Returned Code	Returned Message	Description
200	Operation succeeded.	Requesting succeeded.
10001	Parameters error.	Parameter is empty or the format is incorrect.
10002	accessToken exception or expired.	Get accessToken again.
10005	appKey exception.	appKey is frozen.
20002	Device does not exist.	
20006	Network exception.	Check the network status. Try again.
20007	The device is offline.	Check whether the device is online.
20008	Device requesting timeout.	No more operations. Try again.
20014	Network exception.	Check the network status. Try again.
20018	The user does not have this device.	Check whether the device belongs to the current account.
49999	Data exception.	Calling the API exception.
60022	It is the current status.	It is the current switch status.
1.3 Delete Detector

Function
The API is used to delete the A1 series device linked detector.

Request Address

{areaDomain}/api/lapp/detector/delete

Request Method

POST

Request Parameters

Parameter	Type	Description	Required
accessToken	String	The access_token during authentication.	Y
deviceSerial	String	The device serial No..	Y
detectorSerial	String	Detector No.	Y
HTTP Request Message
POST /api/lapp/detector/delete HTTP/1.1
Host: isgpopen.ezvizlife.com
Content-Type: application/x-www-form-urlencoded
accessToken=at.9mqitppidgce4y8n54ranvyqc9fjtsrl&deviceSerial=569262222&detectorSerial=604216666
Returned Data
{
    "code": "200",
    "msg": "Operation succeeded!"
}
Returned Code
Returned Code	Returned Message	Description
200	Operation succeeded.	Requesting succeeded.
10001	Parameters error.	Parameter is empty or the format is incorrect.
10002	accessToken exception or expired.	Get accessToken again.
10005	appKey exception.	appKey is frozen.
20002	Device does not exist.	
20006	Network exception.	Check the network status. Try again.
20007	The device is offline.	Check whether the device is online.
20008	Device requesting timeout.	No more operations. Try again.
20014	Network exception.	Check the network status. Try again.
20018	The user does not have this device.	Check whether the device belongs to the current account.
49999	Data exception.	Calling the API exception.
1.4 Get IPC List to be Linked

Function
The API is used to get IPC list which can be linked to A1 series device.

Request Address

{areaDomain}/api/lapp/detector/ipc/list/bindable

Request Method

POST

Request Parameters

Parameter	Type	Description	Required
accessToken	String	The access_token during authentication.	Y
deviceSerial	String	The device serial No..	Y
HTTP Request Message
POST /api/lapp/detector/ipc/list/bindable HTTP/1.1
Host: isgpopen.ezvizlife.com
Content-Type: application/x-www-form-urlencoded
accessToken=at.9mqitppidgce4y8n54ranvyqc9fjtsrl&deviceSerial=569262222
Returned Data
{
    "data": [
        {
            "deviceSerial": "428888888",
            "channelNo": 1,
            "cameraName": "Outdoor"
        },
        {
            "deviceSerial": "426666666",
            "channelNo": 1,
            "cameraName": "Indoo"
        }
    ],
    "code": "200",
    "msg": "Operation succeeded!"
}
Returned Filed
Field	Type	Description
deviceSerial	String	IPC serial No.
channelNo	int	Channel No.
cameraName	int	IPC Name
Returned Code
Returned Code	Returned Message	Description
200	Operation succeeded.	Requesting succeeded.
10001	Parameters error.	Parameter is empty or the format is incorrect.
10002	accessToken exception or expired.	Get accessToken again.
10005	appKey exception.	appKey is frozen.
20002	Device does not exist.	
20014	Network exception.	Check the network status. Try again.
20018	The user does not have this device.	Check whether the device belongs to the current account.
49999	Data exception.	Calling the API exception.
1.5 Get Linked IPC List

Function
The API is used to get A1 series device linked IPC list.

Request Address

{areaDomain}/api/lapp/detector/ipc/list/bind

Request Method

POST

Request Parameters

Parameter	Type	Description	Required
accessToken	String	The access_token during authentication.	Y
deviceSerial	String	The device serial No..	Y
detectorSerial	String	The detector No..	Y
HTTP Request Message
POST /api/lapp/detector/ipc/list/bind HTTP/1.1
Host: isgpopen.ezvizlife.com
Content-Type: application/x-www-form-urlencoded
accessToken=at.8gxgysai9hh0uzr4bnl8jgt23nepm05a&deviceSerial=465538888&detectorSerial=470289999
Returned Data
{
  "data": [
    {
      "detectorSerial": "470289999",
      "ipcSerial": "558815555"
    }
  ],
  "code": "200",
  "msg": "Operation succeeded!"
}
Returned Filed
Field	Type	Description
deviceSerial	String	IPC serial No.
ipcSerial	String	The linked IPC serial No..
Returned Code
Returned Code	Returned Message	Description
200	Operation succeeded.	Requesting succeeded.
10001	Parameters error.	Parameter is empty or the format is incorrect.
10002	accessToken exception or expired.	Get accessToken again.
10005	appKey exception.	appKey is frozen.
20002	Device does not exist.	
20014	Network exception.	Check the network status. Try again.
20018	The user does not have this device.	Check whether the device belongs to the current account.
49999	Data exception.	Calling the API exception.
1.6 Set Linkage Relation between Detector and IPC

Function
The API is used to set linkage relation between A1 series device linked detector and IPC.

Request Address

{areaDomain}/api/lapp/detector/ipc/relation/set

Request Method

POST

Request Parameters

Parameter	Type	Description	Required
accessToken	String	The access_token during authentication.	Y
deviceSerial	String	The device serial No..	Y
detectorSerial	String	The detector No..	Y
ipcSerial	String	IPC serial No..	Y
operation	int	Operation: 0-delete, 1-bind	Y
HTTP Request Message
POST /api/lapp/detector/ipc/relation/set HTTP/1.1
Host: isgpopen.ezvizlife.com
Content-Type: application/x-www-form-urlencoded
accessToken=at.8gxgysai9hh0uzr4bnl8jgt23nepm05a&deviceSerial=465538888&detectorSerial=470289999&ipcSerial=558815555&operation=0
Returned Data
{
  "code": "200",
  "msg": "Operation succeeded!"
}
Returned Code
Returned Code	Returned Message	Description
200	Operation succeeded.	Requesting succeeded.
10001	Parameters error.	Parameter is empty or the format is incorrect.
10002	accessToken exception or expired.	Get accessToken again.
10005	appKey exception.	appKey is frozen.
20002	Device does not exist.	
20006	Network exception.	Check the network status. Try again.
20007	The device is offline.	Check whether the device is online.
20008	Device requesting timeout.	No more operations. Try again.
20014	Network exception.	Check the network status. Try again.
20018	The user does not have this device.	Check whether the device belongs to the current account.
49999	Data exception.	Calling the API exception.
60020	The command is not supported.	Check whether the device supports IPC related functions.
1.7 Edit Detector Name

Function
The API is used to edit the detector name.

Request Address

{areaDomain}/api/lapp/detector/name/change

Request Method

POST

Request Method

Parameter	Type	Description	Required
accessToken	String	The access_token during authentication.	Y
deviceSerial	String	The device serial No..	Y
detectorSerial	String	The detector No..	Y
newName	String	New name, the length is less than 50 and without special characters.	Y
HTTP Request Message
POST /api/lapp/detector/name/change HTTP/1.1
Host: isgpopen.ezvizlife.com
Content-Type: application/x-www-form-urlencoded
accessToken=at.8gxgysai9hh0uzr4bnl8jgt23nepm05a&deviceSerial=465538888&detectorSerial=470289999&newName=mydetector
Returned Data
{
  "code": "200",
  "msg": "Operation succeeded!"
}
Returned Code
Returned Code	Returned Message	Description
200	Operation succeeded.	Requesting succeeded.
10001	Parameters error.	Parameter is empty or the format is incorrect.
10002	accessToken exception or expired.	Get accessToken again.
10005	appKey exception.	appKey is frozen.
20002	Device does not exist.	
20006	Network exception.	Check the network status. Try again.
20007	The device is offline.	Check whether the device is online.
20008	Device requesting timeout.	No more operations. Try again.
20014	Network exception.	Check the network status. Try again.
20018	The user does not have this device.	Check whether the device belongs to the current account.
49999	Data exception.	Calling the API exception.
1.8 One-touch Clear Alarm for Device

Function
The API is used to clear alarm for A1 series devices remotely (It should be supported by the device).

Request Address

{areaDomain}/api/lapp/detector/cancelAlarm

Request Method

POST

Request Parameters

Parameter	Type	Description	Required
accessToken	String	The access_token during authentication.	Y
deviceSerial	String	The device serial No..	Y
HTTP Request Message
POST /api/lapp/detector/cancelAlarm HTTP/1.1
Host: isgpopen.ezvizlife.com
Content-Type: application/x-www-form-urlencoded
accessToken=at.8gxgysai9hh0uzr4bnl8jgt23nepm05a&deviceSerial=465538888
Returned Data
{
  "code": "200",
  "msg": "Operation succeeded!"
}
Returned Code
Returned Code	Returned Message	Description
200	Operation succeeded.	Requesting succeeded.
10001	Parameters error.	Parameter is empty or the format is incorrect.
10002	accessToken exception or expired.	Get accessToken again.
10005	appKey exception.	appKey is frozen.
20002	Device does not exist.	
20006	Network exception.	Check the network status. Try again.
20007	The device is offline.	Check whether the device is online.
20008	Device requesting timeout.	No more operations. Try again.
20014	Network exception.	Check the network status. Try again.
20018	The user does not have this device.	Check whether the device belongs to the current account.
49999	Data exception.	Calling the API exception.
1.9 Set device associated with detector

API Function

This interface is used to associate the device with the detector (the device needs to support remote association of the detector, and the distance between the device and the detector cannot exceed 1 meter）

Request Address

{areaDomain}/api/lapp/detector/add

Request Type

POST

Minimum permissions required for sub-account token requests

"Permission":"Config" "Resource":"dev:dev: serial number"

Request Parameters

Parameter name	Type	Description	Required
accessToken	String	access_token obtained by the authorization process	Y
deviceSerial	Strring	Device serial number	Y
detectorSerial	String	detector serial number	Y
detectorType	String	detector model (see [detector type description] (#detector_type))	Y
detectorCode	String	detector verification code (must enter ABCDEF)	Y
Http Request Message
 POST /api/lapp/detector/add HTTP/1.1
 Host: http://localhost:8080
 Content-Type: application/x-www-form-urlencoded

 accessToken=at.3y9qa2697b3eif5m4l20kla43ahb6wwk-3gml098d0z-0g4mher-wikgosg5m&deviceSerial=Q01478043&detectorSerial=Q00786518&detectorType=T2&detectorCode=ABCDEF
Http Request Message
 {
     "code": "200",
     "msg": "Operation succeeded"
 }
Return Code
Return code	Return message	Description
200	Operate successfully	Requested successfully
10001	Parameter error	The parameter is empty or the format is incorrect
10002	Abnormal or expired AccessToken	re-accessAccessToken
10005	Abnormal appKey	appKey is frozen
20002	Device does not exist	
20006	Network anomaly	Check the device network status, try again later
20007	Device response timed out	Check if the device is online
20008	The device is not online	Operating too frequently, try again later
20014	deviceSerial is illegal	
20018	The user does not own the device	Check if the device belongs to the current account
49999	Data exception	Interface call exception
50000	Service exception	System service exception
Description of detector type
Detector model	Detector type	Detector type name
T4	FIRE	Smoke Detector
T3	CALLHELP	Emergency Button
T2	MAGNETOMETER	Magnetic Contact
T1	PIR	IR Detector
T5	CURTAIN	Curtain
K2	TELECONTROL	Remote Control
T6	MOVE_MAGNETOMETER	Open-close Detector
T9	ALERTOR	Alarm Device
T8	GAS	Combustible Gas
T10	WATERLOGGING	Water Leak



Query the fill light mode（GET）

Query the fill light mode Hosted/subaccount: Supported Limits of authority：Get

Interface URL

{areaDomain}/api/v3/device/fillLight/mode/get

Request

Header

name	type	required	desc	Examples refer to and refer to apis
accessToken	string	Y	Ezviz Open API access token	 
deviceSerial	string	Y	SN	 
Reponse

Return data

name	type	desc	example
status	int	status	 
body	object	body	 
-meta	object	meta	 
--code	int	code	 
--message	string	message	 
-data	object	data	 
--deviceSerial	string	deviceSerial	 
--graphicType	int	graphicType	 
--luminance	int	luminance	 
--duration	int	duration	 
Return example

{
    status:200,
        body:{
        meta:{
            code:200,
            message:"Operation succeeded"
        },
        data:{
            deviceSerial:"GDA8052E04F99490CB6826:79BF4971B",
            graphicType:2, //Fill light type,0 black and white 1 full color 2 smart
            luminance:100, //Brightness fixed 100
            duration:5 //Automatic light on duration, fixed 5 seconds
        }
        }
}  
Error code

Status code	Error code	Error message	solution
200	200	Operation succeeded	 
400	10001	{parameter} is not empty	 
400	20014	Invalid deviceSerial!	 
403	20018	The user doesn't own the device.	 
403	10031	The account does not have permission to access this device	 
404	20002	device not exist	 
422	60020	the device does not support the signaling	 
200	10002	AccessToken expired or error	 
500	50000	Server error	


Set the fill light mode（POST）

Hosted/subaccount: Supported Limits of authority：Config

InterfaceURL

{areaDomain}/api/v3/device/fillLight/mode/set

Request

Header

name	type	required	desc	Examples refer to and refer to apis
accessToken	string	Y	Ezviz Open API access token	 
deviceSerial	string	Y	SN	 
query

name	type	required	desc	Examples refer to and refer to apis
mode	string	Y	0- "Black and White Night Vision" mode 1- "Full Color Night Vision" mode 2- "Smart Night Vision"	 
Reponse

Return data

name	type	desc	example
status	int	status	 
body	object	body	 
-meta	object	meta	 
--code	int	code	 
--message	string	message	 
Return example

{
    status:200,
        body:{
              meta:{
                code:200,
                message:"Operation succeeded"
          }
        }
}
Error code

Status code	Error code	Error message	solution
200	200	Operation succeeded	 
400	10001	{parameter} is not empty	 
400	20014	Invalid deviceSerial!	 
403	20018	The user doesn't own the device.	 
403	10031	The account does not have permission to access this device	 
403	10036	The sub-account is frozen.	 
400	49999	Data error	 
404	20002	device not exist	 
412	20007	The device is offline.	 
422	60020	the device does not support the signaling	 
408	20006	network anomaly	 
408	20008	Device response timeout.	 
401	30001	The user doesn't exist.	 
403	20010	incorrect device verification code	 
412	60058	The device has high risk, demand authentication	 
400	60012	Unknown error	 
200	10002	AccessToken expired or error	 



Query device switch（GET）

Query device switch Hosted/subaccount: Supported Limits of authority：Get

Interface URL

{areaDomain}/api/v3/device/switchStatus/get

Request

Header

name	type	required	desc	Examples refer to and refer to apis
accessToken	string	Y	Ezviz Open API access token	 
deviceSerial	string	Y	SN	 
query

name	type	required	desc	Examples refer to and refer to apis
type	string	Y	301- Light flicker switch/Motion detection light linkage	 
Response

Return data

name	type	desc	example
status	int	status	 
body	object	body	 
-meta	object	meta	 
--code	int	code	 
--message	string	message	 
-data	object	data	 
--subSerial	string	subSerial	 
--type	int	type	 
--enable	int	enable	 
Return example

{
    status:200,
        body:{
        meta:{
            code:200,
            message:"Operation succeeded"
        },
        data:{
            subSerial:"GDA8052E04F99490CB6826:79BF4971B",
            type:2, //Switch type,301- Light flashing switch/Motion detection light linkage
            enable:1 //Switch status,0- Off, 1- On
        }
        }
}  
Error code

Status code	Error code	Error message	solution
200	200	Operation succeeded	 
400	10001	{parameter} is not empty	 
400	20014	Invalid deviceSerial!	 
403	20018	The user doesn't own the device.	 
403	10031	The account does not have permission to access this device	 
404	20002	device not exist	 
422	60020	the device does not support the signaling	 
200	10002	AccessToken expired or error	 
500	50000	Server error	 


Set device switch（POST）

Set device switch Hosted/subaccount: Supported Limits of authority：Config

Interface URL

{areaDomain}/api/v3/device/switchStatus/set

Request

Header

name	type	required	desc	Examples refer to and refer to apis
accessToken	string	Y	Ezviz Open API access token	 
deviceSerial	string	Y	SN	 
query

name	type	required	desc	Examples refer to and refer to apis
enable	string	Y	Switch status,0- Off, 1- On	 
type	string	Y	301- Light flicker switch/Motion detection light linkage	 
Response

Return data

name	type	desc	example
status	int	status	 
body	object	body	 
-meta	object	meta	 
--code	int	code	 
--message	string	message	 
Return example

{
    status:200,
        body:{
              meta:{
                code:200,
                message:"Operation succeeded"
          }
        }
}
Error code

Status code	Error code	Error message	solution
200	200	Operation succeeded	 
400	10001	{parameter} is not empty	 
400	20014	Invalid deviceSerial!	 
403	20018	The user doesn't own the device.	 
403	10031	The account does not have permission to access this device	 
400	49999	Data error	 
404	20002	device not exist	 
412	20007	The device is offline.	 
422	60020	the device does not support the signaling	 
408	20006	network anomaly	 
408	20008	Device response timeout.	 
401	30001	The user doesn't exist.	 
403	20010	incorrect device verification code	 
412	60058	The device has high risk, demand authentication	 
400	60012	Unknown error	 
200	10002	AccessToken expired or error	 



Query the device working mode plan（GET）

Query the device working mode plan Hosted/subaccount: Supported Limits of authority：Get

Interface URL

{areaDomain}/api/v3/device/timing/plan/get

Request

Header

name	type	required	desc	Examples refer to and refer to apis
accessToken	string	Y	Ezviz Open API access token	 
deviceSerial	string	Y	SN	 
Response

Return data

name	type	desc	Example
status	int	status	 
body	object	body	 
-meta	object	meta	 
--code	int	code	 
--message	string	message	 
-data	object	data	 
--subSerial	string	subSerial	 
--subType	int	subType	 
--weekPlans	array<object>	weekPlans	 
---weekDay	string	weekDay	 
---timePlan	array<object>	timePlan	 
----beginTime	string	beginTime	 
----endTime	string	endTime	 
----eventArg	string	eventArg	 
Return example

{
    status:200,
        body:{
        meta:{
            code:200,
            message:"Operation succeeded"
        },
        data:{
            subSerial:"GDA8052E04F99490CB6826:79BF4971B",
            subType:2,
            weekPlans:[
                {
                    weekDay:"0,1", //Weekly repeat 0: Sunday,1: Monday,2: Tuesday,3: Wednesday,4: Thursday,5: Friday.6: Saturday
                    timePlan:[
                        {
                            beginTime:"08:00",//The start time of every day
                            endTime:"18:00",//The end of the day
                            eventArg:"mode:1"//Planned event Execution parameters 0: Power saving 1: performance 2: normal power saving 3: super power saving mode
                        }
                    ]
                }
            ]
        }
         }
}
Error code

Status code	Error code	Error message	solution
200	200	Operation succeeded	 
400	10001	{parameter} is not empty	 
400	20014	Invalid deviceSerial!	 
403	20018	The user doesn't own the device.	 
403	10031	The account does not have permission to access this device	 
404	20002	device not exist	 
422	60020	the device does not support the signaling	 
200	10002	AccessToken expired or error	 
500	50000	Server error	 


Set the device working mode plan（POST）

Set the device working mode plan Hosted/subaccount: Supported Limits of authority：Config

Interface URL

{areaDomain}/api/v3/device/timing/plan/set

Request

Header

name	type	required	desc	Examples refer to and refer to apis
accessToken	string	Y	Ezviz Open API access token	 
deviceSerial	string	Y	SN	 
body

name	type	required	desc	Examples refer to and refer to apis
enable	string	Y	1- enabled, 0- disabled (CS-CB3-R100-2D2WFL type equipment is not effective after equipment research and development, if you have any questions about other equipment, you can find the relevant personnel to confirm)	 
startTime	string	Y	Start time 08:00 every day	 
endTime	string	Y	End time of day 18:00	 
week	string	Y	1:0: Sunday, Monday, 2:3: on Tuesday, Wednesday, 4: Thursday, 5: Friday. 6: Saturday, parameter format: 0,1,2,3,4,6	 
eventArg	string	N	0: Power saving 1: performance 2: normal 3: Super power saving mode (default: 0)	 
Response

Return data

name	type	desc	Example
status	int	status	 
body	object	body	 
-meta	object	meta	 
--code	int	code	 
--message	string	message	 
Return example

{
    status:200,
        body:{
              meta:{
                 code:200,
                 message:"Operation succeeded"
          }
       }
}
Error code

Status code	Error code	Error message	solution
200	200	Operation succeeded	 
400	10001	{parameter} is not empty	 
400	20014	Invalid deviceSerial!	 
403	20018	The user doesn't own the device.	 
403	10031	The account does not have permission to access this device	 
400	49999	Data error	 
404	20002	device not exist	 
412	20007	The device is offline.	 
422	60020	the device does not support the signaling	 
408	20006	network anomaly	 
408	20008	Device response timeout.	 
200	10002	AccessToken expired or error	&n



Query the alarm sound enablement switch（GET）

Query the alarm sound enablement switch Hosted/subaccount: Supported Limits of authority：Get

Interface URL

{areaDomain}/api/v3/device/alarmSound/enabled/get

Request

Header

name	type	required	desc	Examples refer to and refer to apis
accessToken	string	Y	Ezviz Open API access token	 
deviceSerial	string	Y	SN	 
Response

Return data

name	type	desc	Example
status	int	status	 
body	object	body	 
-meta	object	meta	 
--code	int	code	 
--message	string	message	 
-data	object	data	 
--deviceSerial	string	deviceSerial	 
--alarmSoundMode	int	alarmSoundMode	 
Return example

{
    status:200,
        body:{
        meta:{
            code:200,
            message:"Operation succeeded"
        },
        data:{
                        deviceSerial:"123",
            alarmSoundMode:2, //Type 0- Short call 1- Long call 2- Mute
        }
         }
}
Error code

Status code	Error code	Error message	solution
200	200	Operation succeeded	 
400	10001	{parameter} is not empty	 
400	20014	Invalid deviceSerial!	 
403	20018	The user doesn't own the device.	 
403	10031	The account does not have permission to access this device	 
404	20002	device not exist	 
422	60020	the device does not support the signaling	 
200	10002	AccessToken expired or error	 
500	50000	Server error	 


Set the alarm sound function（POST）

    Set the alarm sound function Hosted/subaccount: Supported Limits of authority：Config
    
    Interface URL
    
    {areaDomain}/api/v3/device/alarmSound/enabled/set
    
    Request
    
    Header
    
    name	type	required	desc	Examples refer to and refer to apis
    accessToken	string	Y	Ezviz Open API access token	 
    deviceSerial	string	Y	SN	 
    query
    
    name	type	required	desc	Examples refer to and refer to apis
    type	string	Y	0- Short call, 1- Long call, 2- Mute	 
    Response
    
    Return data
    
    name	type	desc	Example
    status	int	status	 
    body	object	body	 
    -meta	object	meta	 
    --code	int	code	 
    --message	string	message	 
    Return example
    
    {
        status:200,
            body:{
                  meta:{
                     code:200,
                     message:"Operation succeeded"
             }
           }
    }
    Error code
    
    Status code	Error code	Error message	solution
    200	200	Operation succeeded	 
    400	10001	{parameter} is not empty	 
    400	20014	Invalid deviceSerial!	 
    403	20018	The user doesn't own the device.	 
    403	10031	The account does not have permission to access this device	 
    400	49999	Data error	 
    404	20002	device not exist	 
    412	20007	The device is offline.	 
    422	60020	the device does not support the signaling	 
    408	20006	network anomaly	 
    408	20008	Device response timeout.	 
    401	30001	The user doesn't exist.	 
    403	20010	incorrect device verification code	 
    412	60058	The device has high risk, demand authentication	 
    400	60012	Unknown error	 
    200	10002	AccessToken expired or error	



    Query detection area（GET）

Query detection area,Supports screen change detection and humanoid detection area query Hosted/subaccount: Supported Limits of authority：get

Interface URL

https://open.ys7.com/api/v3/device/motion/detect/get

Request

Header

name	type	required	desc	Examples refer to and refer to apis
accessToken	string	Y	Ezviz Open API access token	 
deviceSerial	string	Y	SN	 
channelNo	string	Y	Channel number	 
Response

Return data

name	type	desc	Example
status	int	status	 
body	object	body	 
-meta	object	meta	 
--code	int	code	 
--message	string	message	 
-data	object	data	 
--deviceSerial	string	deviceSerial	 
--channelNo	int	channelNo	 
--rows	int	rows	 
--columns	int	columns	 
--area	array<integer>	area	 
Return example

{
    status:200,
        body:{
        meta:{
            code:200,
            message:"Operation succeeded"
        },
        data:{
            deviceSerial:"GDA8052E04F99490CB6826:79BF4971B",
            channelNo:2,
            rows:0,//Configure zone division, rows, and equal detection distances
            columns:0,//Configure area division columns to equally divide the probe angles
            area:[0,48,3,3, 0,0,0,0, 0,0,0,3, 0,0,0,0, 0,0,0,0]//Detection area
        }
        }
}    
Error code

Status code	Error code	Error message	solution
200	200	Operation succeeded	 
400	10001	{parameter} is not empty	 
400	20014	Invalid deviceSerial!	 
403	20018	The user doesn't own the device.	 
403	10031	The account does not have permission to access this device	 
404	20002	device not exist	 
412	20007	The device is offline.	 
200	10002	AccessToken expired or error	 
500	50000	Server error	


Set detection area（POST）

Set detection area，Support humanoid detection area, picture change detection area drawing Hosted/subaccount: Supported Limits of authority：Config

Interface URL

{areaDomain}/api/v3/device/motion/detect/set

Request

Header

name	type	required	desc	Examples refer to and refer to apis
accessToken	string	Y	Ezviz Open API access token	 
deviceSerial	string	Y	SN	 
channelNo	string	Y	Channel number	 
query

name	type	required	desc	Examples refer to and refer to apis
area	string	Y	Detection area eq:8,8,8	 
Response

Return data

name	type	desc	Example
status	int	status	 
body	object	body	 
-meta	object	meta	 
--code	int	code	 
--message	string	message	 
Return example

{
    status:200,
        body:{
               meta:{
                   code:200,
                   message:"Operation succeeded"
           }
        }
}
Error code

Status code	Error code	Error message	solution
200	200	Operation succeeded	 
400	10001	{parameter} is not empty	 
400	20014	Invalid deviceSerial!	 
403	20018	The user doesn't own the device.	 
403	10031	The account does not have permission to access this device	 
400	49999	Data error	 
404	20002	device not exist	 
412	20007	The device is offline.	 
422	60020	the device does not support the signaling	 
408	20006	network anomaly	 
408	20008	Device response timeout.	 
200	10002	AccessToken expired or error	



Play ringtone（POST）

Play ringtone Hosted/subaccount: Supported Limits of authority：Config

Interface URL

{areaDomain}/api/v3/device/audition

Request

Header

name	type	required	desc	Examples refer to and refer to apis
accessToken	string	Y	Ezviz Open API access token	 
deviceSerial	string	Y	SN	 
query

name	type	required	desc	Examples refer to and refer to apis
voiceIndex	string	Y	Voice Index Alert Mode Beep: 200 Alarm mode Beep Alarm: 201 Mute: 202	 
volume	string	N	The default value is 1, 1-100	 
Response

Return data

name	type	desc	Example
status	int	status	 
body	object	body	 
-meta	object	meta	 
--code	int	code	 
--message	string	message	 
Return example

{
    status:200,
        body:{
            meta:{
            code:200,
            message:"Operation succeeded"
        }
       }
}
Error code

Status code	Error code	Error message	solution
200	200	Operation succeeded	 
400	10001	{parameter} is not empty	 
400	20014	Invalid deviceSerial!	 
403	20018	The user doesn't own the device.	 
403	10031	The account does not have permission to access this device	 
400	49999	Data error	 
404	20002	device not exist	 
412	20007	The device is offline.	 
422	60020	the device does not support the signaling	 
408	20006	network anomaly	 
408	20008	Device response timeout.	 
200	10002	AccessToken expired or error	 


Get the device formatting status（GET）

Get the device formatting status Hosted/subaccount: Supported Limits of authority：get

Interface URL

{areaDomain}/api/v3/device/format/status

Request

Header

name	type	required	desc	Examples refer to and refer to apis
accessToken	string	Y	Ezviz Open API access token	 
deviceSerial	string	Y	SN	 
Response

Return data

name	type	desc	Example
status	int	status	 
body	object	body	 
-meta	object	meta	 
--code	int	code	 
--message	string	message	 
-data	object	data	 
--storageStatus	array<object>	storageStatus	 
---index	int	index	 
---name	string	name	 
---status	int	status	 
---formattingRate	string	formattingRate	 
---capacity	int	capacity	 
Return example

{
    status:200,
        body:{
        meta:{
            code:200,
            message:"Operation succeeded"
        },
        data:{
            storageStatus:[
                {
                    index:0,//Storage medium number
                    name:"名称",//Storage medium name
                    status:0,//Status of the storage medium: 0 is normal,1 is the storage medium is incorrect,2 is not formatted, and 3 is formatting
                    formattingRate:"20%",//Formatting progress
                                       "capacity":231313
                }
            ]
        }
        }
}
Error code

Status code	Error code	Error message	solution
200	200	Operation succeeded	 
400	10001	{parameter} is not empty	 
400	20014	Invalid deviceSerial!	 
403	20018	The user doesn't own the device.	 
403	10031	The account does not have permission to access this device	 
404	20002	device not exist	 
412	20007	The device is offline.	 
412	60058	The device has high risk, demand authentication	 
422	20011	device exception	 
200	10002	AccessToken expired or error	 




Formatting device disk（PUT）

Hosted/subaccount: Supported Limits of authority：Format

Interface URL

{areaDomain}/api/v3/device/format/disk

Request

Header

name	type	required	desc	Examples refer to and refer to apis
accessToken	string	Y	Ezviz Open API access token	 
deviceSerial	string	Y	SN	 
query

name	type	required	desc	Examples refer to and refer to apis
diskIndex	string	Y	Storage medium number	 
Response

Return data

name	type	desc	Example
status	int	status	 
body	object	body	 
-meta	object	meta	 
--code	int	code	 
--message	string	message	 
Return example

{
    status:200,
        body:{
                meta:{
              code:200,
              message:"Operation succeeded"
            }
        }
}
Error code

Status code	Error code	Error message	解决方案
200	200	Operation succeeded	 
400	10001	{parameter} is not empty	 
400	20014	Invalid deviceSerial!	 
403	20018	The user doesn't own the device.	 
403	10031	The account does not have permission to access this device	 
400	49999	Data error	 
404	20002	device not exist	 
412	20007	The device is offline.	 
408	20006	network anomaly	 
408	20008	Device response timeout.	 
403	20010	incorrect device verification code	 
412	60058	The device has high risk, demand authentication	 
400	60012	Unknown error	 
422	20011	device exception	 
422	20016	The device is currently being formatted	 
200	10002	AccessToken expired or error	



1. API List

This section introduces the cloud storage related APIs。

API List:

No.	API Function	Description
1	Enable Cloud Storage for Device via Card Password	Enable the cloud storage for device via Cloud P2P storage card password.
2	Search Device Cloud Storage Information	Search the device cloud storage related information
1.1 Enable Cloud Storage for Device via Card Password

Function： This API is used to enable the cloud storage function via Cloud P2P storage card password. （Buy Cloud Storage Card Passowrd）

Request Address

{areaDomain}/api/lapp/cloud/storage/open

Request Method

POST

Request Parameters

Parameters	Type	Description	Required
accessToken	String	The access_token obtained during authentication.	Y
deviceSerial	long	Enable the device serial No. for cloud storage user.	Y
cardPassword	String	Cloud Storage Card Password	Y
phone	String	(Optional) Enable the phone number for cloud storage user.	N
channelNo	int	(Optional) Not Empty - Enable the cloud storage for the specified channel; Empty - Enable the cloud storage for the device itself. The default value is 1.	N
isImmediately	int	Enable: 0-No (Default), 1-Yes Note: 0 means enabling the function not immediately. You can enable the function when the cloud storage service stopped; 1 means enabling the function immediately. If the cloud service exists and the service type is the same with the current one, you can renew the function on the current service, or the original service will be overlapped.	N
HTTP Request Message
POST /api/lapp/cloud/storage/open HTTP/1.1
Host: isgpopen.ezvizlife.com
Content-Type: application/x-www-form-urlencoded
accessToken=at.4fal4i1y0er1bw476c5z53f63dsjkwrl&deviceSerial=596510666&channelNo=1&phone=18888888888&cardPassword=4326717075050976&isImmediately=0
Returned Value
{
    "code":"200",
    "msg":"Operation succeeded!"
}
Returned Code
Returned Code	Returned Message	Description
200	Operation succeeded.	Requesting succeeded.
10001	Parameters error.	Parameter is empty or the format is incorrect.
10002	accessToken exception or expired.	Get accessToken again.
10004	The user does not exist.	
10005	appKey exception.	appKey is frozen.
20002	Device does not exist.	
20014	Illegal deviceSerial	
20018	The user does not have this device.	The phone corresponding user does not have this device.
20032	The channel does not exist in this user.	The channel does not exist in this user.
49999	Data exception.	Calling the API exception.
60012	Unknown error.	
60020	The device does not support cloud storage.	The device does not support cloud storage or the current device version does not cloud storage. It can be supported after upgrading.
60030	No more incorrect card password attempts are allowed. Input again after 24 hours.	The incorrect card password attempts exceed the limit.
60031	Card password information does not exist.	Check whether the card password is correct.
60032	Card password status error.	The card password is not activated or is already used or is expired.
60033	The card password is not for sale. Only the binding device can be enabled.	Card password not for sale.
60035	Enabling the cloud storage service failed.	When the error code or the prompt of "enabling cloud storage parameters error" appears, you should send the information, such as phone number, device serial No., or card password, to open-team@ezvizlife.com.
1.2 Search device cloud storage information

Function

This API is used to search the device cloud storage information.

Request Address

{areaDomain}/api/lapp/cloud/storage/device/info

Request Method

POST

Request Parameters

Parameters	Type	Description	Required
accessToken	String	The access_token obtained during authentication.	Y
deviceSerial	long	Search the device serial No. for cloud storage user.	Y
phone	String	(Optional) Enable the phone number for cloud storage user.	N
channelNo	int	(Optional) Not Empty - Search the specified channel cloud storage information; Empty - Search the device itself cloud storage information. The default value is 1.	N
HTTP Request Message
POST /api/lapp/cloud/storage/device/info HTTP/1.1
Host: isgpopen.ezvizlife.com
Content-Type: application/x-www-form-urlencoded
accessToken=at.4fal4i1y0er1bw476c5z53f63dsjkwrl&deviceSerial=596510666&channelNo=1&phone=18888888888
Returned Data
{
    "data": {
        "userName": "ezviz",
        "deviceSerial": "596510666",
        "channelNo": 1,
        "totalDays": 7,
        "status": 1,
        "validDays": 280,
        "startTime": 1470370451000,
        "expireTime": 1603107852000,
        "serviceDetail": {
            "userName": "ezviz",
            "deviceSerial": "596510666",
            "channelNo": 1,
            "totalDays": 30,
            "startTime": 1539949152000,
            "expireTime": 1603107852000,
            "status": 0
        }
    },
    "code": "200",
    "msg": "Operation succeeded!"
}
Returned Field：
Field	Type	Description
userName	String	The user name for cloud storage service.
deviceSerial	String	Device serial No.
channelNo	int	Channel No.
totalDays	int	Cloud storage service recording period.
status	int	Cloud Storage Status, -2: The device does not support, -1: Cloud storage is disabled, 0: Not activated, 1: Activated, 2: Expired.
validDays	int	Valid Days
startTime	long	Cloud storage service start time, exactly on the second.
expireTime	long	Cloud storage service stop time, exactly on the second.
serviceDetail	Object	Different types of cloud storage service information. Only when the device has two types of the cloud storage service, the parameter will be valid.
Returned Code
Returned Code	Returned Message	Description
200	Operation succeeded.	Requesting succeeded.
10001	Parameters error.	Parameter is empty or the format is incorrect.
10002	accessToken exception or expired.	Get accessToken again.
10004	The user does not exist.	
10005	appKey exception.	appKey is frozen.
20002	Device does not exist.	
20014	Illegal deviceSerial	
20018	The user does not have this device.	The phone corresponding user does not have this device.
49999	Data exception.	Calling the API exception.
60012	Unknown error.	




1、API List

This part includes sub-accounts related API.

Following is the API list：

No	Function	Description
1	create sub-account	Create a sub-account in B (big account) mode
2	get single subaccount information	Get selected sub-acount information
3	get sub-account information list	Get sub-account information list in different page
4	edit sub-account password	Edit sub-account password
5	edit sub-account Permission strategy	Edit sub-account Permission strategy
6	add sub-account permission	Add sub-account statement in Permission strategy
7	delete sub-account permission	Delete one device’s all statement in sub-account
8	get sub-account AccessToken	Get sub-account AccessToken
9	delete sub-account	delete sub-account
Common Return Code
Returned Code	Returned Infromation	Description
200	Operation succeed	Request succeed
10001	Parameter error	No parameter or wrong format
10013	Your application has no permission to call the API	
10002	accessToken error or expiration	Get accessToken again
10005	appKey error	appKey locked
10031	The sub-account or the EZVIZ user has no permission	
10032	Sub-account not exist	
10034	Sub-account name already exist	
10035	Getting sub-account AccessToken error	
10036	The sub-account is frozen.	
50000	Operation failed	Operation failed
1.1Create Sub-Account

Function

Create a sub-account in B (big account) mode.(sub-account functions description)

Request Address

{areaDomain}/api/lapp/ram/account/create

Request Method

POST

Request Parameters

Parameters	Type	Description	Required
accessToken	String	The access token got from permission	Y
accountName	String	Sub-account name, 4-40 letters or characters	Y
password	String	Sub-account passwordLowerCase(MD5(AppKey#Passwords plaintext))	Y
LowerCase(MD5(AppKey#Passwords plaintext)):for AppKey use MD5 encryption to # and plaintext, and transfer to lower letters

HTTP Request Message

POST /api/lapp/ram/account/create HTTP/1.1
Host: isgpopen.ezvizlife.com
Content-Type: application/x-www-form-urlencoded

accessToken=at.9307p5ye4yilog2f9apn82368j9g62g1-2rs1w3h0k0-092yx3m-ysd3i9cg9&accountName=test&password=5305b671da2d66785f7e6dd24c117370
Return Data
{
    "data": {
        "accountId": "b3ad7ba927524b748e557572024d4ac2"
    },
    "code": "200",
    "msg": "Operation succeeded!"
}
Return Filed：
Filed Name	Type	Description
accountId	String	Sub-account id
Return Code

Common Return Code

1.2 Get Single Sub-Account Information

Function:

This port is used for access selected sub-account information.(sub-account function discerption)

Request Address

{areaDomain}/api/lapp/ram/account/get

Request Method

POST

Request Parameters

Parameter	Type	Description	Required
accessToken	String	The access token got from permission	Y
accountId	String	Sub-account id	N
accountName	String	Sub-account name	N
If the accessToken parameter is the same type of sub-account’s AccessToken, the accountId and accountName’s parameter can be none. If not, one of them must not be none, if both of them are not none, port return accountID sub-account information.

HTTP Request Message
POST /api/lapp/ram/account/get HTTP/1.1
Host: isgpopen.ezvizlife.com
Content-Type: application/x-www-form-urlencoded

accessToken=at.9307p5ye4yilog2f9apn82368j9g62g1-2rs1w3h0k0-092yx3m-ysd3i9cg9&accountId=b3ad7ba927524b748e557572024d4ac2
Return Data
{
    "data": {
        "accountId": "b3ad7ba927524b748e557572024d4ac2",
        "accountName": "test",
        "appKey": "ae1b9af9dcac4caeb88da6dbbf2dd8d5",
        "accountStatus": 1,
        "policy": {
            "Statement": [
                {
                    "Permission": "GET,UPDATE,REAL",
                    "Resource": [
                        "dev:469631729",
                        "dev:519928976",
                        "cam:544229080:1"
                    ]
                },
                {
                    "Permission": "GET",
                    "Resource": [
                        "dev:470686804"
                    ]
                }
            ]
        }
    },
    "code": "200",
    "msg": "Operation succeeded!"
}
Return Filed:
Filed Name	type	description
accountId	String	Sub-account id
accountName	String	Sub-account name
appKey	String	Sub-account belonged app’s AppKey
accountStatus	int	Sub-account status. 0 is off, 1 is on
policy	Policy	Sub-account permission strategy
Policy type(Policy grammar structure)：

Filed Name	Type	Description
Statement	Array[Statement]	Statement
Statement type：

Filed Name	Type	Description
Permission	String	Permission list
Resource	Array[String]	Resource list
Return Code

Common Return Code

1.3 Access Sub-account Information List

Function:

This port is used for get sub-account information in different pages(sub-account function description)

Request Address

{areaDomain}/api/lapp/ram/account/list

Request Method

POST

Request Parameters

Parameter	Type	Description	Required
accessToken	String	accessToken got from permission	Y
pageStart	int	Page starts at 0	N
pageSize	int	Page size, default 10, max 50	N
HTTP Request Message
POST /api/lapp/ram/account/get HTTP/1.1
Host: isgpopen.ezvizlife.com
Content-Type: application/x-www-form-urlencoded

accessToken=at.9307p5ye4yilog2f9apn82368j9g62g1-2rs1w3h0k0-092yx3m-ysd3i9cg9&pageStart=0&pageSize=2
Return Data
{
    "page": {
        "total": 15,
        "page": 0,
        "size": 2
    },
    "data": [
        {
            "accountId": "b3ad7ba927524b748e557572024d4ac2",
            "accountName": "test",
            "appKey": "ae1b9af9dcac4caeb88da6dbbf2dd8d5",
            "accountStatus": 1,
            "policy": {
                "Statement": [
                    {
                        "Permission": "GET,UPDATE,REAL",
                        "Resource": [
                            "dev:469631729",
                            "dev:519928976",
                            "cam:544229080:1"
                        ]
                    },
                    {
                        "Permission": "GET",
                        "Resource": [
                            "dev:470686804"
                        ]
                    }
                ]
            }
        },
        {
            "accountId": "0058a3964698415d8a70a931faa48d78",
            "accountName": "test2",
            "appKey": "ae1b9af9dcac4caeb88da6dbbf2dd8d5",
            "accountStatus": 1,
            "policy": null
        }
    ],
    "code": "200",
    "msg": "Operation succeeded!"
}
Return Filed:
Filed Name	Type	Description
page	Page	Page information
data	Array[Account]	Sub-account information list
code	String	Sub-account information list
msg	String	Operation message
Page type

Filed Name	type	description
total	long	Total record count
page	long	Start page
size	long	Page size
Account type

Filed Name	Type	Description
accountId	String	Sub-account id
accountName	String	Sub-account name
appKey	String	Sub account apps’ AppKey
accountStatus	int	Sub-account status, 0 is off, 1 is on
policy	Policy	Sub-account permission strategy
Policy type (Policy grammar structure)：

Filed Name	Type	Description
Statement	Array[Statement]	statement
Statement type：

Filed Name	Type	Description
Permission	String	Permission list
Resource	Array[String]	Resource list
Return Code

Common Return Code

1.4 Edit Current Sub-account Password

Function

This port is used for edit current sub-account password

Request Address

{areaDomain}/api/lapp/ram/account/updatePassword

Request Method

POST

Request Parameters

Parameter	Type	Description	Required
accessToken	String	The accessToken got from permission	Y
accountId	String	Sub-account id	Y
oldPassword	String	Old password ,LowerCase(MD5(AppKey#plaintext))	Y
newPassword	String	New password LowerCase(MD5(AppKey#plaintext))	Y
LowerCase(MD5(AppKey#plaintext)):for AppKey use MD5 encryption to # and plaintext, and transfer to lower letters

HTTP Request Message

POST /api/lapp/ram/account/updatePassword HTTP/1.1
Host: isgpopen.ezvizlife.com
Content-Type: application/x-www-form-urlencoded

accessToken=at.9307p5ye4yilog2f9apn82368j9g62g1-2rs1w3h0k0-092yx3m-ysd3i9cg9&accountId=b3ad7ba927524b748e557572024d4ac2&oldPassword=5305b671da2d66785f7e6dd24c117370&newPassword=cc03e747a6afbbcbf8be7668acfebee5
Return Data
{
    "code": "200",
    "msg": "Operation succeeded!"
}
Return Code

Common Return Code

1.5 Edit Sub-account Permission Strategy

Function:

This port is used for edit mode B sub-account permission strategy

Request Address

{areaDomain}/api/lapp/ram/policy/set

Request Method

POST

Request Parameters

Parameter	Type	Description	Required
accessToken	String	The accessToken got from permission	Y
accountId	String	Sub-account Id	Y
policy	String	Permission strategy,Policy grammar sentence structure	Y
HTTP Request Message
POST /api/lapp/ram/policy/set HTTP/1.1
Host: isgpopen.ezvizlife.com
Content-Type: application/x-www-form-urlencoded

accessToken=at.9307p5ye4yilog2f9apn82368j9g62g1-2rs1w3h0k0-092yx3m-ysd3i9cg9&policy=%7B%22Statement%22%3A%5B%7B%22Permission%22%3A+%22GET%2CUPDATE%2CREAL%22%2C%22Resource%22%3A%5B%22dev%3A469631729%22%2C%22dev%3A519928976%22%2C%22cam%3A544229080%3A1%22%5D%7D%5D%7D&accountId=b3ad7ba927524b748e557572024d4ac2
Return Data
{
    "code": "200",
    "msg": "Operation succeed!"
}
Return Code

Common Return Code

1.6 Add Sub-account Permission

Function:

This port is used for add sub-account statement in permission strategy

Request Address

{areaDomain}/api/lapp/ram/statement/add

Request Method

POST

Request Parameters

Parameter	Type	Description	Required
accessToken	String	The accessToken from permission	Y
accountId	String	Sub-account Id	Y
statement	String	Statement,Statement grammar structure,For example:{"Permission": "GET", "Resource": ["dev:469631729"]}	Y
HTTP Request Message
POST /api/lapp/ram/statement/add HTTP/1.1
Host: isgpopen.ezvizlife.com
Content-Type: application/x-www-form-urlencoded

accessToken=at.9307p5ye4yilog2f9apn82368j9g62g1-2rs1w3h0k0-092yx3m-ysd3i9cg9&statement==%7B%22Permission%22%3A+%22GET%22%2C+%22Resource%22%3A+%5B%22dev%3A547596317%22%5D%7D&accountId=b3ad7ba927524b748e557572024d4ac2
Return Data
{
    "code": "200",
    "msg": "Operation succeed!"
}
Return Code

Common Return Code

1.7 Delete Sub-Account Permission

Function

This port is used for delete one device’s all statement in a sub-account

Request Address

{areaDomain}/api/lapp/ram/statement/delete

Request Method

POST

Request Parameters

Parameter	Type	Description	Required
accessToken	String	The accessToken got from permission	Y
accountId	String	Sub-account Id	Y
deviceSerial	String	Device serial number	Y
HTTP Request Message
POST /api/lapp/ram/statement/delete HTTP/1.1
Host: isgpopen.ezvizlife.com
Content-Type: application/x-www-form-urlencoded

accessToken=at.9307p5ye4yilog2f9apn82368j9g62g1-2rs1w3h0k0-092yx3m-ysd3i9cg9&deviceSerial==547596317&accountId=b3ad7ba927524b748e557572024d4ac2
Return Data
{
    "code": "200",
    "msg": "Operation succeeded!"
}
Return Code

Common Return Code

1.8 Access Mode B Sub-Account AccessToken

Function

This port is used for access mode B sub-account accessToken

Request Address

{areaDomain}/api/lapp/ram/token/get

Request Method

POST

Request Parameters

Parameter	Type	Description	Required
accessToken	String	The accessToken got from permission	Y
accountId	String	sub-account Id	Y
HTTP Request Message
POST /api/lapp/ram/token/get HTTP/1.1
Host: isgpopen.ezvizlife.com
Content-Type: application/x-www-form-urlencoded

accessToken=at.9307p5ye4yilog2f9apn82368j9g62g1-2rs1w3h0k0-092yx3m-ysd3i9cg9&accountId=b3ad7ba927524b748e557572024d4ac2
Return Data
{
    "data": {
        "accessToken": "ra.7jrcjmna8qnqg8d3dgnzs87m4v2dme3l-32enpqgusd-1jvdfe4-uxo15ik0s",
        "expireTime": 1470810222045,
        "areaDomain": "https://iusopen.ezvizlife.com"
    },
    "code": "200",
    "msg": "Operation succeed !"
}
Return Code

Common Return Code

1.9 Delete Sub-Account

Function

This port is used for delete sub-account

Request Address

{areaDomain}/api/lapp/ram/account/delete

Request Method

POST

Request Parameters

Parameter	Type	Description	Required
accessToken	String	The accessToken got from permission	Y
accountId	String	sub-account Id	Y
HTTP Request Message
POST /api/lapp/ram/account/delete HTTP/1.1
Host: isgpopen.ezvizlife.com
Content-Type: application/x-www-form-urlencoded

accessToken=at.9307p5ye4yilog2f9apn82368j9g62g1-2rs1w3h0k0-092yx3m-ysd3i9cg9&accountId=b3ad7ba927524b748e557572024d4ac2
Return Data
{
    "code": "200",
    "msg": "Operation succeed !"
}
Return Code

Common Return Code


