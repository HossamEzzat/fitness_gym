// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'member.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MemberStatusAdapter extends TypeAdapter<MemberStatus> {
  @override
  final int typeId = 1;

  @override
  MemberStatus read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return MemberStatus.active;
      case 1:
        return MemberStatus.expiringSoon;
      case 2:
        return MemberStatus.expired;
      default:
        return MemberStatus.active;
    }
  }

  @override
  void write(BinaryWriter writer, MemberStatus obj) {
    switch (obj) {
      case MemberStatus.active:
        writer.writeByte(0);
        break;
      case MemberStatus.expiringSoon:
        writer.writeByte(1);
        break;
      case MemberStatus.expired:
        writer.writeByte(2);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MemberStatusAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
