require 'rails_helper'

RSpec.describe PrivateConversation, type: :model do

  it { is_expected.to validate_presence_of(:sender) }
  it { is_expected.to validate_presence_of(:recipient) }
  it { is_expected.to validate_length_of(:participantships).with_message("needs exactly two conversation participants") }

  it "has a valid factory" do
    expect(build(:private_conversation)).to be_valid
  end

  it "creates a conversation between sender and recipient" do
    conversation = PrivateConversation.new(:sender => create(:user), :recipient => create(:user))
    expect(conversation).to be_valid
    expect(conversation.save).to be true
    expect(conversation.participants.size).to eq(2)
  end

  it "deletes the participantship associations" do
    conversation = PrivateConversation.create(:sender => create(:user), :recipient => create(:user))
    expect(PrivateConversation.all.size).to eq(1)
    expect(ParticipantshipInPrivateConversation.all.size).to eq(2)
    expect(User.all.size).to eq(2)
    
    conversation.destroy
    expect(PrivateConversation.all.size).to eq(0)
    expect(ParticipantshipInPrivateConversation.all.size).to eq(0)
    expect(User.all.size).to eq(2)
  end

  it "must have two participants" do
    conversation = PrivateConversation.new(:sender => create(:user), :recipient => create(:user))
    conversation.participantships.clear

    # create with zero participants -> fail
    expect(conversation).not_to be_valid
    expect(conversation.errors.messages).to include(:participantships)

    # create with one participants -> fail
    conversation.participantships.build(participant: create(:user))
    expect(conversation).not_to be_valid
    expect(conversation.errors.messages).to include(:participantships)

    # create with two participants -> success
    conversation.participantships.build(participant: create(:user))
    expect(conversation).to be_valid
    expect(conversation.errors.messages).not_to include(:participantships)

    # create with three participants -> fail
    conversation.participantships.build(participant: create(:user))
    expect(conversation).not_to be_valid
    expect(conversation.errors.messages).to include(:participantships)

    # create with four participants -> fail
    conversation.participantships.build(participant: create(:user))
    expect(conversation).not_to be_valid
    expect(conversation.errors.messages).to include(:participantships)

    # create with five participants -> fail
    conversation.participantships.build(participant: create(:user))
    expect(conversation).not_to be_valid
    expect(conversation.errors.messages).to include(:participantships)

  end

  it "does not create conversation if another between sender and recipient already exists" do
    @user_one = create(:user)
    @user_two = create(:user)

    conversation = PrivateConversation.create(:sender => @user_one, :recipient => @user_two)
    expect(conversation.participants.size).to eq(2)

    same_conversation = PrivateConversation.new(:sender => @user_one, :recipient => @user_two)
    expect(same_conversation).not_to be_valid
    expect(same_conversation.errors.full_messages).
      to include("You already have a conversation with #{same_conversation.recipient.name}.")

  end

end
