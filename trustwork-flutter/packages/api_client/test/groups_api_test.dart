import 'package:test/test.dart';
import 'package:api_client/api_client.dart';


/// tests for GroupsApi
void main() {
  final instance = ApiClient().getGroupsApi();

  group(GroupsApi, () {
    // Add Member
    //
    // Admin adds a member (must be an accepted contact of the admin).
    //
    //Future<GroupDetail> addMemberGroupsGroupIdMembersPost(int groupId, MemberSuggestionCreate memberSuggestionCreate) async
    test('test addMemberGroupsGroupIdMembersPost', () async {
      // TODO
    });

    // Create Group
    //
    // Create a group. The creator becomes the admin (joined); members are invited.  Every member must be an accepted contact of the creator (403 otherwise).
    //
    //Future<GroupDetail> createGroupGroupsPost(GroupCreate groupCreate) async
    test('test createGroupGroupsPost', () async {
      // TODO
    });

    // Decline Group
    //
    // Decline a group invite.
    //
    //Future declineGroupGroupsGroupIdDeclinePost(int groupId) async
    test('test declineGroupGroupsGroupIdDeclinePost', () async {
      // TODO
    });

    // Dismiss Suggestion
    //
    // Admin dismisses a suggestion without inviting.
    //
    //Future dismissSuggestionGroupsGroupIdSuggestionsSuggestionIdDismissPost(int groupId, int suggestionId) async
    test('test dismissSuggestionGroupsGroupIdSuggestionsSuggestionIdDismissPost', () async {
      // TODO
    });

    // Get Group
    //
    // Group detail, including member identities.  Requires a *joined* membership — joining is the consent that reveals co-members' identities. Invitees who haven't joined use `invite-preview` (counts only, no names).
    //
    //Future<GroupDetail> getGroupGroupsGroupIdGet(int groupId) async
    test('test getGroupGroupsGroupIdGet', () async {
      // TODO
    });

    // Invite Preview
    //
    // Counts an invitee needs to decide. Names of unknown members are withheld.
    //
    //Future<GroupInvitePreview> invitePreviewGroupsGroupIdInvitePreviewGet(int groupId) async
    test('test invitePreviewGroupsGroupIdInvitePreviewGet', () async {
      // TODO
    });

    // Invite Suggested
    //
    // Admin acts on a suggestion by inviting the suggested person.  Works even if the admin doesn't know the suggested person: the `invited` membership row authorizes the admin→invitee Matrix invite for this room (decision B), so no prior contact is required.
    //
    //Future<GroupDetail> inviteSuggestedGroupsGroupIdSuggestionsSuggestionIdInvitePost(int groupId, int suggestionId) async
    test('test inviteSuggestedGroupsGroupIdSuggestionsSuggestionIdInvitePost', () async {
      // TODO
    });

    // Join Group
    //
    // Accept a group invite: join the room and become contacts with joined members.
    //
    //Future<GroupDetail> joinGroupGroupsGroupIdJoinPost(int groupId) async
    test('test joinGroupGroupsGroupIdJoinPost', () async {
      // TODO
    });

    // Leave Group
    //
    // Leave a group. Contact edges gained in the group persist.
    //
    //Future leaveGroupGroupsGroupIdLeavePost(int groupId) async
    test('test leaveGroupGroupsGroupIdLeavePost', () async {
      // TODO
    });

    // List Groups
    //
    // Groups I'm in or invited to.
    //
    //Future<BuiltList<GroupSummary>> listGroupsGroupsGet() async
    test('test listGroupsGroupsGet', () async {
      // TODO
    });

    // List Suggestions
    //
    // Admin lists pending suggestions.
    //
    //Future<BuiltList<MemberSuggestion>> listSuggestionsGroupsGroupIdSuggestionsGet(int groupId) async
    test('test listSuggestionsGroupsGroupIdSuggestionsGet', () async {
      // TODO
    });

    // Remove Member
    //
    // Admin removes a member. Contact edges persist; only room membership is severed.
    //
    //Future removeMemberGroupsGroupIdMembersMatrixUserIdDelete(int groupId, String matrixUserId) async
    test('test removeMemberGroupsGroupIdMembersMatrixUserIdDelete', () async {
      // TODO
    });

    // Suggest Member
    //
    // A member suggests someone for the admin to invite.
    //
    //Future<MemberSuggestion> suggestMemberGroupsGroupIdSuggestionsPost(int groupId, MemberSuggestionCreate memberSuggestionCreate) async
    test('test suggestMemberGroupsGroupIdSuggestionsPost', () async {
      // TODO
    });

  });
}
