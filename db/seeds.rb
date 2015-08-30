# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)


# Adding 'Book's here
Book.create([
  {title: "百科英语"}
])


# Adding 'Unit's here
Book.first.units.create(subtitle: "Earth", sequence_id: 1)


# Adding 'Case's here
Book.first.units.find_by(sequence_id: 1).cases.create(sequence_id: 1)


# Adding 'Video's here
Book.first.units.find_by(sequence_id: 1).cases.find_by(sequence_id: 1).videos.create(youku_id: '123456789', sequence_id: 1)


# Adding 'Exercise's here
Book.first.units.find_by(sequence_id: 1).cases.find_by(sequence_id: 1).exercises.create(sequence_id: 1)
Book.first.units.find_by(sequence_id: 1).cases.find_by(sequence_id: 1).exercises.create(sequence_id: 2)


# Adding 'Word's here
Book.first.units.find_by(sequence_id: 1).cases.find_by(sequence_id: 1).exercises.find_by(sequence_id: 1).words.create([
  {chinese: '一个;一', english: 'one', partofspeech: 'NUM', source_title: 'Oxford', grade: 4, semester: 1},
  {chinese: '鸟', english: 'bird', partofspeech: 'N', source_title: 'Oxford', grade: 1, semester: 1}, 
  {chinese: '是', english: 'is', partofspeech: 'V', source_title: 'Oxford', grade: 5, semester: 2},
  {chinese: '在……下面的;在……下的', english: 'under', partofspeech: 'PREP', source_title: 'Oxford', grade: 2, semester: 2},
  {chinese: '树木;树', english: 'tree', partofspeech: 'N', source_title: 'Oxford', grade: 1, semester: 2}
])
Book.first.units.find_by(sequence_id: 1).cases.find_by(sequence_id: 1).exercises.find_by(sequence_id: 2).words.create([
  {chinese: '我', english: 'I', partofspeech: 'PROM', source_title: 'Oxford', grade: 3, semester: 2},
  {chinese: '拥有;有;吃', english: 'have', partofspeech: 'V', source_title: 'Oxford', grade: 3, semester: 2},
  {chinese: '一个', english: 'a', partofspeech: 'ART', source_title: 'Oxford', grade: 4, semester: 1},
  {chinese: '对;双', english: 'pair', partofspeech: 'N', source_title: 'Oxford', grade: 3, semester: 1},
  {chinese: '的', english: 'of', partofspeech: 'PREP', source_title: 'Oxford', grade: 2, semester: 2},
  {chinese: '橙色的', english: 'orange', partofspeech: 'ADJ', source_title: 'Oxford', grade: 1, semester: 2},
  {chinese: '短袜', english: 'sock', partofspeech: 'N', source_title: 'Oxford', grade: 1, semester: 1}
])


# Adding 'Component's here
Book.first.units.find_by(sequence_id: 1).cases.find_by(sequence_id: 1).exercises.find_by(sequence_id: 1).components.create([
  {name: 'CARD STH', reduciable: false},
  {name: 'STH BE PREP STH', reduciable: true},
  {name: 'DET STH', reduciable: true}
])
Book.first.units.find_by(sequence_id: 1).cases.find_by(sequence_id: 1).exercises.find_by(sequence_id: 2).components.create([
  {name: 'STH DO', reduciable: false},
  {name: 'DO STH', reduciable: false},
  {name: 'ART STH', reduciable: false},
  {name: 'STH OF STH', reduciable: false},
  {name: 'ADJ STH', reduciable: false}
])


# Add relationship between words and sentences
Word.find(1).sentences.create({chinese: '一只鸟在那颗树下。', english: 'One bird is under that tree.', equivalents: "A bird is under that tree.; There's a bird under the tree.; There is a bird under the tree.", core_id: 3, structure: "[CARD sth] be PREP [ART sth]", source_title: 'Oxford', grade: 4, semester: 1})
Word.find(2).sentences.append(Sentence.find_by(english: 'One bird is under that tree.'))
Word.find(3).sentences.append(Sentence.find_by(english: 'One bird is under that tree.'))
Word.find(4).sentences.append(Sentence.find_by(english: 'One bird is under that tree.'))
Word.find(5).sentences.append(Sentence.find_by(english: 'One bird is under that tree.'))
Word.find(6).sentences.create({chinese: '我有一双橙色的短袜。', english: 'I have a pair of orange socks.', core_id: 4, structure: "sth do [[ART sth] of [ADJ sth]]", source_title: 'Oxford', grade: 5, semester: 2})
Word.find(7).sentences.append(Sentence.find_by(english: 'I have a pair of orange socks.'))
Word.find(8).sentences.append(Sentence.find_by(english: 'I have a pair of orange socks.'))
Word.find(9).sentences.append(Sentence.find_by(english: 'I have a pair of orange socks.'))
Word.find(10).sentences.append(Sentence.find_by(english: 'I have a pair of orange socks.'))
Word.find(11).sentences.append(Sentence.find_by(english: 'I have a pair of orange socks.'))
Word.find(12).sentences.append(Sentence.find_by(english: 'I have a pair of orange socks.'))


# Add connection between components and sentences
Component.find(1).sentences.append(Sentence.find_by(english: 'One bird is under that tree.'))
Component.find(2).sentences.append(Sentence.find_by(english: 'One bird is under that tree.'))
Component.find(3).sentences.append(Sentence.find_by(english: 'One bird is under that tree.'))
Component.find(4).sentences.append(Sentence.find_by(english: 'I have a pair of orange socks.'))
Component.find(5).sentences.append(Sentence.find_by(english: 'I have a pair of orange socks.'))
Component.find(6).sentences.append(Sentence.find_by(english: 'I have a pair of orange socks.'))
Component.find(7).sentences.append(Sentence.find_by(english: 'I have a pair of orange socks.'))
Component.find(8).sentences.append(Sentence.find_by(english: 'I have a pair of orange socks.'))


