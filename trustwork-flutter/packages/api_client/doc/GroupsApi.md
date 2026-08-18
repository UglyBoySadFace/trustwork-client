# api_client.api.GroupsApi

## Load the API package
```dart
import 'package:api_client/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**addMemberGroupsGroupIdMembersPost**](GroupsApi.md#addmembergroupsgroupidmemberspost) | **POST** /groups/{group_id}/members | Add Member
[**createGroupGroupsPost**](GroupsApi.md#creategroupgroupspost) | **POST** /groups | Create Group
[**declineGroupGroupsGroupIdDeclinePost**](GroupsApi.md#declinegroupgroupsgroupiddeclinepost) | **POST** /groups/{group_id}/decline | Decline Group
[**deleteGroupGroupsGroupIdDelete**](GroupsApi.md#deletegroupgroupsgroupiddelete) | **DELETE** /groups/{group_id} | Delete Group
[**dismissSuggestionGroupsGroupIdSuggestionsSuggestionIdDismissPost**](GroupsApi.md#dismisssuggestiongroupsgroupidsuggestionssuggestioniddismisspost) | **POST** /groups/{group_id}/suggestions/{suggestion_id}/dismiss | Dismiss Suggestion
[**getGroupGroupsGroupIdGet**](GroupsApi.md#getgroupgroupsgroupidget) | **GET** /groups/{group_id} | Get Group
[**invitePreviewGroupsGroupIdInvitePreviewGet**](GroupsApi.md#invitepreviewgroupsgroupidinvitepreviewget) | **GET** /groups/{group_id}/invite-preview | Invite Preview
[**inviteSuggestedGroupsGroupIdSuggestionsSuggestionIdInvitePost**](GroupsApi.md#invitesuggestedgroupsgroupidsuggestionssuggestionidinvitepost) | **POST** /groups/{group_id}/suggestions/{suggestion_id}/invite | Invite Suggested
[**joinGroupGroupsGroupIdJoinPost**](GroupsApi.md#joingroupgroupsgroupidjoinpost) | **POST** /groups/{group_id}/join | Join Group
[**leaveGroupGroupsGroupIdLeavePost**](GroupsApi.md#leavegroupgroupsgroupidleavepost) | **POST** /groups/{group_id}/leave | Leave Group
[**listGroupsGroupsGet**](GroupsApi.md#listgroupsgroupsget) | **GET** /groups | List Groups
[**listSuggestionsGroupsGroupIdSuggestionsGet**](GroupsApi.md#listsuggestionsgroupsgroupidsuggestionsget) | **GET** /groups/{group_id}/suggestions | List Suggestions
[**removeMemberGroupsGroupIdMembersMatrixUserIdDelete**](GroupsApi.md#removemembergroupsgroupidmembersmatrixuseriddelete) | **DELETE** /groups/{group_id}/members/{matrix_user_id} | Remove Member
[**renameGroupGroupsGroupIdPatch**](GroupsApi.md#renamegroupgroupsgroupidpatch) | **PATCH** /groups/{group_id} | Rename Group
[**suggestMemberGroupsGroupIdSuggestionsPost**](GroupsApi.md#suggestmembergroupsgroupidsuggestionspost) | **POST** /groups/{group_id}/suggestions | Suggest Member
[**transferAdminGroupsGroupIdTransferAdminPost**](GroupsApi.md#transferadmingroupsgroupidtransferadminpost) | **POST** /groups/{group_id}/transfer-admin | Transfer Admin


# **addMemberGroupsGroupIdMembersPost**
> GroupDetail addMemberGroupsGroupIdMembersPost(groupId, memberSuggestionCreate)

Add Member

Admin adds a member (must be an accepted contact of the admin).

### Example
```dart
import 'package:api_client/api.dart';
// TODO Configure OAuth2 access token for authorization: OAuth2PasswordBearer
//defaultApiClient.getAuthentication<OAuth>('OAuth2PasswordBearer').accessToken = 'YOUR_ACCESS_TOKEN';

final api = ApiClient().getGroupsApi();
final int groupId = 56; // int | 
final MemberSuggestionCreate memberSuggestionCreate = ; // MemberSuggestionCreate | 

try {
    final response = api.addMemberGroupsGroupIdMembersPost(groupId, memberSuggestionCreate);
    print(response);
} on DioException catch (e) {
    print('Exception when calling GroupsApi->addMemberGroupsGroupIdMembersPost: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **groupId** | **int**|  | 
 **memberSuggestionCreate** | [**MemberSuggestionCreate**](MemberSuggestionCreate.md)|  | 

### Return type

[**GroupDetail**](GroupDetail.md)

### Authorization

[OAuth2PasswordBearer](../README.md#OAuth2PasswordBearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **createGroupGroupsPost**
> GroupDetail createGroupGroupsPost(groupCreate)

Create Group

Create a group. The creator becomes the admin (joined); members are invited.  Every member must be an accepted contact of the creator (403 otherwise).

### Example
```dart
import 'package:api_client/api.dart';
// TODO Configure OAuth2 access token for authorization: OAuth2PasswordBearer
//defaultApiClient.getAuthentication<OAuth>('OAuth2PasswordBearer').accessToken = 'YOUR_ACCESS_TOKEN';

final api = ApiClient().getGroupsApi();
final GroupCreate groupCreate = ; // GroupCreate | 

try {
    final response = api.createGroupGroupsPost(groupCreate);
    print(response);
} on DioException catch (e) {
    print('Exception when calling GroupsApi->createGroupGroupsPost: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **groupCreate** | [**GroupCreate**](GroupCreate.md)|  | 

### Return type

[**GroupDetail**](GroupDetail.md)

### Authorization

[OAuth2PasswordBearer](../README.md#OAuth2PasswordBearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **declineGroupGroupsGroupIdDeclinePost**
> declineGroupGroupsGroupIdDeclinePost(groupId)

Decline Group

Decline a group invite.  The invite card's delivery room goes with it, so the admin keeps no room to message someone who turned the group down. A later re-invite gets a fresh one.

### Example
```dart
import 'package:api_client/api.dart';
// TODO Configure OAuth2 access token for authorization: OAuth2PasswordBearer
//defaultApiClient.getAuthentication<OAuth>('OAuth2PasswordBearer').accessToken = 'YOUR_ACCESS_TOKEN';

final api = ApiClient().getGroupsApi();
final int groupId = 56; // int | 

try {
    api.declineGroupGroupsGroupIdDeclinePost(groupId);
} on DioException catch (e) {
    print('Exception when calling GroupsApi->declineGroupGroupsGroupIdDeclinePost: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **groupId** | **int**|  | 

### Return type

void (empty response body)

### Authorization

[OAuth2PasswordBearer](../README.md#OAuth2PasswordBearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **deleteGroupGroupsGroupIdDelete**
> deleteGroupGroupsGroupIdDelete(groupId)

Delete Group

Admin deletes the group: memberships, suggestions and the room all go.  The Matrix room is purged (everyone is forced out), so no one is left holding a room for a group that no longer exists. Contact edges people gained by joining **persist** — decision A says they outlive the group.

### Example
```dart
import 'package:api_client/api.dart';
// TODO Configure OAuth2 access token for authorization: OAuth2PasswordBearer
//defaultApiClient.getAuthentication<OAuth>('OAuth2PasswordBearer').accessToken = 'YOUR_ACCESS_TOKEN';

final api = ApiClient().getGroupsApi();
final int groupId = 56; // int | 

try {
    api.deleteGroupGroupsGroupIdDelete(groupId);
} on DioException catch (e) {
    print('Exception when calling GroupsApi->deleteGroupGroupsGroupIdDelete: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **groupId** | **int**|  | 

### Return type

void (empty response body)

### Authorization

[OAuth2PasswordBearer](../README.md#OAuth2PasswordBearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **dismissSuggestionGroupsGroupIdSuggestionsSuggestionIdDismissPost**
> dismissSuggestionGroupsGroupIdSuggestionsSuggestionIdDismissPost(groupId, suggestionId)

Dismiss Suggestion

Admin dismisses a suggestion without inviting.

### Example
```dart
import 'package:api_client/api.dart';
// TODO Configure OAuth2 access token for authorization: OAuth2PasswordBearer
//defaultApiClient.getAuthentication<OAuth>('OAuth2PasswordBearer').accessToken = 'YOUR_ACCESS_TOKEN';

final api = ApiClient().getGroupsApi();
final int groupId = 56; // int | 
final int suggestionId = 56; // int | 

try {
    api.dismissSuggestionGroupsGroupIdSuggestionsSuggestionIdDismissPost(groupId, suggestionId);
} on DioException catch (e) {
    print('Exception when calling GroupsApi->dismissSuggestionGroupsGroupIdSuggestionsSuggestionIdDismissPost: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **groupId** | **int**|  | 
 **suggestionId** | **int**|  | 

### Return type

void (empty response body)

### Authorization

[OAuth2PasswordBearer](../README.md#OAuth2PasswordBearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getGroupGroupsGroupIdGet**
> GroupDetail getGroupGroupsGroupIdGet(groupId)

Get Group

Group detail, including member identities.  Requires a *joined* membership — joining is the consent that reveals co-members' identities. Invitees who haven't joined use `invite-preview` (counts only, no names).

### Example
```dart
import 'package:api_client/api.dart';
// TODO Configure OAuth2 access token for authorization: OAuth2PasswordBearer
//defaultApiClient.getAuthentication<OAuth>('OAuth2PasswordBearer').accessToken = 'YOUR_ACCESS_TOKEN';

final api = ApiClient().getGroupsApi();
final int groupId = 56; // int | 

try {
    final response = api.getGroupGroupsGroupIdGet(groupId);
    print(response);
} on DioException catch (e) {
    print('Exception when calling GroupsApi->getGroupGroupsGroupIdGet: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **groupId** | **int**|  | 

### Return type

[**GroupDetail**](GroupDetail.md)

### Authorization

[OAuth2PasswordBearer](../README.md#OAuth2PasswordBearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **invitePreviewGroupsGroupIdInvitePreviewGet**
> GroupInvitePreview invitePreviewGroupsGroupIdInvitePreviewGet(groupId)

Invite Preview

Counts an invitee needs to decide. Names of unknown members are withheld.

### Example
```dart
import 'package:api_client/api.dart';
// TODO Configure OAuth2 access token for authorization: OAuth2PasswordBearer
//defaultApiClient.getAuthentication<OAuth>('OAuth2PasswordBearer').accessToken = 'YOUR_ACCESS_TOKEN';

final api = ApiClient().getGroupsApi();
final int groupId = 56; // int | 

try {
    final response = api.invitePreviewGroupsGroupIdInvitePreviewGet(groupId);
    print(response);
} on DioException catch (e) {
    print('Exception when calling GroupsApi->invitePreviewGroupsGroupIdInvitePreviewGet: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **groupId** | **int**|  | 

### Return type

[**GroupInvitePreview**](GroupInvitePreview.md)

### Authorization

[OAuth2PasswordBearer](../README.md#OAuth2PasswordBearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **inviteSuggestedGroupsGroupIdSuggestionsSuggestionIdInvitePost**
> GroupDetail inviteSuggestedGroupsGroupIdSuggestionsSuggestionIdInvitePost(groupId, suggestionId)

Invite Suggested

Admin acts on a suggestion by inviting the suggested person.  Works even if the admin doesn't know the suggested person: the `invited` membership row authorizes the admin→invitee Matrix invite for this room (decision B), so no prior contact is required.

### Example
```dart
import 'package:api_client/api.dart';
// TODO Configure OAuth2 access token for authorization: OAuth2PasswordBearer
//defaultApiClient.getAuthentication<OAuth>('OAuth2PasswordBearer').accessToken = 'YOUR_ACCESS_TOKEN';

final api = ApiClient().getGroupsApi();
final int groupId = 56; // int | 
final int suggestionId = 56; // int | 

try {
    final response = api.inviteSuggestedGroupsGroupIdSuggestionsSuggestionIdInvitePost(groupId, suggestionId);
    print(response);
} on DioException catch (e) {
    print('Exception when calling GroupsApi->inviteSuggestedGroupsGroupIdSuggestionsSuggestionIdInvitePost: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **groupId** | **int**|  | 
 **suggestionId** | **int**|  | 

### Return type

[**GroupDetail**](GroupDetail.md)

### Authorization

[OAuth2PasswordBearer](../README.md#OAuth2PasswordBearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **joinGroupGroupsGroupIdJoinPost**
> GroupDetail joinGroupGroupsGroupIdJoinPost(groupId)

Join Group

Accept a group invite: join the room and become contacts with joined members.

### Example
```dart
import 'package:api_client/api.dart';
// TODO Configure OAuth2 access token for authorization: OAuth2PasswordBearer
//defaultApiClient.getAuthentication<OAuth>('OAuth2PasswordBearer').accessToken = 'YOUR_ACCESS_TOKEN';

final api = ApiClient().getGroupsApi();
final int groupId = 56; // int | 

try {
    final response = api.joinGroupGroupsGroupIdJoinPost(groupId);
    print(response);
} on DioException catch (e) {
    print('Exception when calling GroupsApi->joinGroupGroupsGroupIdJoinPost: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **groupId** | **int**|  | 

### Return type

[**GroupDetail**](GroupDetail.md)

### Authorization

[OAuth2PasswordBearer](../README.md#OAuth2PasswordBearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **leaveGroupGroupsGroupIdLeavePost**
> leaveGroupGroupsGroupIdLeavePost(groupId)

Leave Group

Leave a group. Contact edges gained in the group persist.  The admin cannot simply leave: a group whose admin is gone can never gain a member again (only the admin invites). They must hand the group over (`transfer-admin`) or delete it.

### Example
```dart
import 'package:api_client/api.dart';
// TODO Configure OAuth2 access token for authorization: OAuth2PasswordBearer
//defaultApiClient.getAuthentication<OAuth>('OAuth2PasswordBearer').accessToken = 'YOUR_ACCESS_TOKEN';

final api = ApiClient().getGroupsApi();
final int groupId = 56; // int | 

try {
    api.leaveGroupGroupsGroupIdLeavePost(groupId);
} on DioException catch (e) {
    print('Exception when calling GroupsApi->leaveGroupGroupsGroupIdLeavePost: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **groupId** | **int**|  | 

### Return type

void (empty response body)

### Authorization

[OAuth2PasswordBearer](../README.md#OAuth2PasswordBearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **listGroupsGroupsGet**
> BuiltList<GroupSummary> listGroupsGroupsGet()

List Groups

Groups I'm in or invited to.

### Example
```dart
import 'package:api_client/api.dart';
// TODO Configure OAuth2 access token for authorization: OAuth2PasswordBearer
//defaultApiClient.getAuthentication<OAuth>('OAuth2PasswordBearer').accessToken = 'YOUR_ACCESS_TOKEN';

final api = ApiClient().getGroupsApi();

try {
    final response = api.listGroupsGroupsGet();
    print(response);
} on DioException catch (e) {
    print('Exception when calling GroupsApi->listGroupsGroupsGet: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**BuiltList&lt;GroupSummary&gt;**](GroupSummary.md)

### Authorization

[OAuth2PasswordBearer](../README.md#OAuth2PasswordBearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **listSuggestionsGroupsGroupIdSuggestionsGet**
> BuiltList<MemberSuggestion> listSuggestionsGroupsGroupIdSuggestionsGet(groupId)

List Suggestions

Admin lists pending suggestions.

### Example
```dart
import 'package:api_client/api.dart';
// TODO Configure OAuth2 access token for authorization: OAuth2PasswordBearer
//defaultApiClient.getAuthentication<OAuth>('OAuth2PasswordBearer').accessToken = 'YOUR_ACCESS_TOKEN';

final api = ApiClient().getGroupsApi();
final int groupId = 56; // int | 

try {
    final response = api.listSuggestionsGroupsGroupIdSuggestionsGet(groupId);
    print(response);
} on DioException catch (e) {
    print('Exception when calling GroupsApi->listSuggestionsGroupsGroupIdSuggestionsGet: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **groupId** | **int**|  | 

### Return type

[**BuiltList&lt;MemberSuggestion&gt;**](MemberSuggestion.md)

### Authorization

[OAuth2PasswordBearer](../README.md#OAuth2PasswordBearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **removeMemberGroupsGroupIdMembersMatrixUserIdDelete**
> removeMemberGroupsGroupIdMembersMatrixUserIdDelete(groupId, matrixUserId)

Remove Member

Admin removes a member. Contact edges persist; only room membership is severed.

### Example
```dart
import 'package:api_client/api.dart';
// TODO Configure OAuth2 access token for authorization: OAuth2PasswordBearer
//defaultApiClient.getAuthentication<OAuth>('OAuth2PasswordBearer').accessToken = 'YOUR_ACCESS_TOKEN';

final api = ApiClient().getGroupsApi();
final int groupId = 56; // int | 
final String matrixUserId = matrixUserId_example; // String | 

try {
    api.removeMemberGroupsGroupIdMembersMatrixUserIdDelete(groupId, matrixUserId);
} on DioException catch (e) {
    print('Exception when calling GroupsApi->removeMemberGroupsGroupIdMembersMatrixUserIdDelete: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **groupId** | **int**|  | 
 **matrixUserId** | **String**|  | 

### Return type

void (empty response body)

### Authorization

[OAuth2PasswordBearer](../README.md#OAuth2PasswordBearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **renameGroupGroupsGroupIdPatch**
> GroupDetail renameGroupGroupsGroupIdPatch(groupId, groupUpdate)

Rename Group

Admin renames the group. The Matrix room name follows (best-effort).  The middleware is the source of truth for the name — clients should rename through here rather than setting `m.room.name` directly, or the two drift.

### Example
```dart
import 'package:api_client/api.dart';
// TODO Configure OAuth2 access token for authorization: OAuth2PasswordBearer
//defaultApiClient.getAuthentication<OAuth>('OAuth2PasswordBearer').accessToken = 'YOUR_ACCESS_TOKEN';

final api = ApiClient().getGroupsApi();
final int groupId = 56; // int | 
final GroupUpdate groupUpdate = ; // GroupUpdate | 

try {
    final response = api.renameGroupGroupsGroupIdPatch(groupId, groupUpdate);
    print(response);
} on DioException catch (e) {
    print('Exception when calling GroupsApi->renameGroupGroupsGroupIdPatch: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **groupId** | **int**|  | 
 **groupUpdate** | [**GroupUpdate**](GroupUpdate.md)|  | 

### Return type

[**GroupDetail**](GroupDetail.md)

### Authorization

[OAuth2PasswordBearer](../README.md#OAuth2PasswordBearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **suggestMemberGroupsGroupIdSuggestionsPost**
> MemberSuggestion suggestMemberGroupsGroupIdSuggestionsPost(groupId, memberSuggestionCreate)

Suggest Member

A member suggests someone for the admin to invite.

### Example
```dart
import 'package:api_client/api.dart';
// TODO Configure OAuth2 access token for authorization: OAuth2PasswordBearer
//defaultApiClient.getAuthentication<OAuth>('OAuth2PasswordBearer').accessToken = 'YOUR_ACCESS_TOKEN';

final api = ApiClient().getGroupsApi();
final int groupId = 56; // int | 
final MemberSuggestionCreate memberSuggestionCreate = ; // MemberSuggestionCreate | 

try {
    final response = api.suggestMemberGroupsGroupIdSuggestionsPost(groupId, memberSuggestionCreate);
    print(response);
} on DioException catch (e) {
    print('Exception when calling GroupsApi->suggestMemberGroupsGroupIdSuggestionsPost: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **groupId** | **int**|  | 
 **memberSuggestionCreate** | [**MemberSuggestionCreate**](MemberSuggestionCreate.md)|  | 

### Return type

[**MemberSuggestion**](MemberSuggestion.md)

### Authorization

[OAuth2PasswordBearer](../README.md#OAuth2PasswordBearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **transferAdminGroupsGroupIdTransferAdminPost**
> GroupDetail transferAdminGroupsGroupIdTransferAdminPost(groupId, groupAdminTransfer)

Transfer Admin

Hand the group to another *joined* member — the way an admin gets to leave.  The new admin takes over inviting and managing members, and is raised to PL 100 in the room. The outgoing admin stays an ordinary member until they leave.

### Example
```dart
import 'package:api_client/api.dart';
// TODO Configure OAuth2 access token for authorization: OAuth2PasswordBearer
//defaultApiClient.getAuthentication<OAuth>('OAuth2PasswordBearer').accessToken = 'YOUR_ACCESS_TOKEN';

final api = ApiClient().getGroupsApi();
final int groupId = 56; // int | 
final GroupAdminTransfer groupAdminTransfer = ; // GroupAdminTransfer | 

try {
    final response = api.transferAdminGroupsGroupIdTransferAdminPost(groupId, groupAdminTransfer);
    print(response);
} on DioException catch (e) {
    print('Exception when calling GroupsApi->transferAdminGroupsGroupIdTransferAdminPost: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **groupId** | **int**|  | 
 **groupAdminTransfer** | [**GroupAdminTransfer**](GroupAdminTransfer.md)|  | 

### Return type

[**GroupDetail**](GroupDetail.md)

### Authorization

[OAuth2PasswordBearer](../README.md#OAuth2PasswordBearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

