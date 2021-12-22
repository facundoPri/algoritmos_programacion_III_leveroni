!classDefinition: #ReceptiveAccountTest category: 'ServiciosFinancieros-Ejercicio'!
TestCase subclass: #ReceptiveAccountTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'ServiciosFinancieros-Ejercicio'!

!ReceptiveAccountTest methodsFor: 'tests' stamp: 'LL 7/1/2021 03:10:43'!
test01ReceptiveAccountHaveZeroAsBalanceWhenCreated 

	| account |
	
	account := ReceptiveAccount new.

	self assert: 0 equals: account balance
! !

!ReceptiveAccountTest methodsFor: 'tests' stamp: 'LL 7/1/2021 03:14:20'!
test02DepositIncreasesBalanceOnTransactionValue 

	| account |
	
	account := ReceptiveAccount  new.
	Deposit register: 100 * peso on: account.
		
	self assert: 100 * peso equals: account balance
! !

!ReceptiveAccountTest methodsFor: 'tests' stamp: 'LL 7/1/2021 03:14:24'!
test03WithdrawDecreasesBalanceOnTransactionValue 

	| account |
	
	account := ReceptiveAccount new.
	Deposit register: 100 * peso on: account.
	Withdraw register: 50 * peso on: account.
		
	self assert: 50 * peso equals: account balance
! !

!ReceptiveAccountTest methodsFor: 'tests' stamp: 'LL 7/1/2021 03:10:14'!
test04WithdrawValueMustBePositive 

	| account withdrawValue |
	
	account := ReceptiveAccount new.
	withdrawValue := 50 * peso.
	
	self assert: withdrawValue equals: (Withdraw register: withdrawValue on: account) value
! !

!ReceptiveAccountTest methodsFor: 'tests' stamp: 'LL 7/1/2021 03:10:22'!
test05ReceptiveAccountKnowsRegisteredTransactions 

	| account deposit withdraw |
	
	account := ReceptiveAccount new.
	deposit := Deposit register: 100 * peso on: account.
	withdraw := Withdraw register: 50 * peso on: account.
		
	self assert: (account hasRegistered: deposit).
	self assert: (account hasRegistered: withdraw).
! !

!ReceptiveAccountTest methodsFor: 'tests' stamp: 'LL 7/1/2021 03:12:14'!
test06ReceptiveAccountDoNotKnowNotRegisteredTransactions

	| account deposit withdraw |
	
	account := ReceptiveAccount new.
	deposit :=  Deposit for: 100 * peso.
	withdraw := Withdraw for: 50 * peso.
		
	self deny: (account hasRegistered: deposit).
	self deny: (account hasRegistered: withdraw).
! !

!ReceptiveAccountTest methodsFor: 'tests' stamp: 'LL 7/1/2021 03:12:23'!
test07AccountKnowsItsTransactions 

	| account deposit |
	
	account := ReceptiveAccount new.
	
	deposit := Deposit register: 50 * peso on: account.
		
	self assert: 1 equals: account transactions size.
	self assert: (account transactions includes: deposit).
! !


!classDefinition: #TransferTest category: 'ServiciosFinancieros-Ejercicio'!
TestCase subclass: #TransferTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'ServiciosFinancieros-Ejercicio'!

!TransferTest methodsFor: 'as yet unclassified' stamp: 'fp 11/21/2021 18:26:41'!
test01DestinationAccountIncreasesBalanceAnOriginAccountDecreasesBalanceOnTransfer

	| destinationAccount originAccount |
	originAccount := ReceptiveAccount new.
	destinationAccount := ReceptiveAccount new.
	
	Transfer from: originAccount to: destinationAccount for: 100 * peso.
	
	self assert: originAccount balance equals: -100 * peso.
	self assert: destinationAccount balance equals: 100 * peso.! !

!TransferTest methodsFor: 'as yet unclassified' stamp: 'fp 11/19/2021 18:16:05'!
test02CannotTransferNegativeAmount

	| destinationAccount originAccount |
	originAccount := ReceptiveAccount new.
	destinationAccount := ReceptiveAccount new.
	
	self
		should: [	Transfer from: originAccount to: destinationAccount for: -100*peso.]
		raise: Error - MessageNotUnderstood 
		withExceptionDo: [:anError |
			self assert: anError messageText = Transfer negativeAmountErrorDescription.
			self assert: destinationAccount balance equals: 0*peso.
			self assert: originAccount balance equals: 0*peso.
		].! !

!TransferTest methodsFor: 'as yet unclassified' stamp: 'fp 11/21/2021 17:57:51'!
test03EachLegAnswersItsCounterparty

	| destinationAccount originAccount aTransference |
	originAccount := ReceptiveAccount new.
	destinationAccount := ReceptiveAccount new.
	
	aTransference := Transfer from: originAccount to: destinationAccount for: 100*peso.
	
	self assert: (aTransference withdrawal) counterparty equals: aTransference deposit.
	self assert: (aTransference deposit) counterparty equals: aTransference withdrawal.! !


!classDefinition: #AccountTransaction category: 'ServiciosFinancieros-Ejercicio'!
Object subclass: #AccountTransaction
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'ServiciosFinancieros-Ejercicio'!

!AccountTransaction methodsFor: 'value' stamp: 'fp 11/21/2021 17:49:06'!
counterparty

	self subclassResponsibility ! !

!AccountTransaction methodsFor: 'value' stamp: 'fp 11/21/2021 18:13:33'!
defineCounterparty: aCounterparty

	self subclassResponsibility ! !

!AccountTransaction methodsFor: 'value' stamp: 'HernanWilkinson 9/12/2011 12:25'!
value 

	self subclassResponsibility ! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'AccountTransaction class' category: 'ServiciosFinancieros-Ejercicio'!
AccountTransaction class
	instanceVariableNames: ''!

!AccountTransaction class methodsFor: 'instance creation' stamp: 'NR 10/17/2019 03:22:00'!
register: aValue on: account

	| transaction |
	
	transaction := self for: aValue.
	account register: transaction.
		
	^ transaction! !


!classDefinition: #Deposit category: 'ServiciosFinancieros-Ejercicio'!
AccountTransaction subclass: #Deposit
	instanceVariableNames: 'value counterparty'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'ServiciosFinancieros-Ejercicio'!

!Deposit methodsFor: 'initialization' stamp: 'HernanWilkinson 7/13/2011 18:45'!
initializeFor: aValue

	value := aValue ! !


!Deposit methodsFor: 'value' stamp: 'fp 11/21/2021 17:48:50'!
counterparty

	^counterparty! !

!Deposit methodsFor: 'value' stamp: 'fp 11/21/2021 18:13:33'!
defineCounterparty: aCounterparty

	counterparty := aCounterparty ! !

!Deposit methodsFor: 'value' stamp: 'fp 11/21/2021 18:11:50'!
transactionValue

	^ value! !

!Deposit methodsFor: 'value' stamp: 'HernanWilkinson 7/13/2011 18:38'!
value

	^ value! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'Deposit class' category: 'ServiciosFinancieros-Ejercicio'!
Deposit class
	instanceVariableNames: ''!

!Deposit class methodsFor: 'instance creation' stamp: 'HernanWilkinson 7/13/2011 18:38'!
for: aValue

	^ self new initializeFor: aValue ! !


!classDefinition: #Withdraw category: 'ServiciosFinancieros-Ejercicio'!
AccountTransaction subclass: #Withdraw
	instanceVariableNames: 'value counterparty'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'ServiciosFinancieros-Ejercicio'!

!Withdraw methodsFor: 'initialization' stamp: 'HernanWilkinson 7/13/2011 18:46'!
initializeFor: aValue

	value := aValue ! !


!Withdraw methodsFor: 'value' stamp: 'fp 11/21/2021 17:48:58'!
counterparty

	^counterparty! !

!Withdraw methodsFor: 'value' stamp: 'fp 11/21/2021 18:13:33'!
defineCounterparty: aCounterparty

	counterparty := aCounterparty ! !

!Withdraw methodsFor: 'value' stamp: 'fp 11/21/2021 18:11:41'!
transactionValue

	^ value negated! !

!Withdraw methodsFor: 'value' stamp: 'fp 11/18/2021 21:36:12'!
value

	^ value! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'Withdraw class' category: 'ServiciosFinancieros-Ejercicio'!
Withdraw class
	instanceVariableNames: ''!

!Withdraw class methodsFor: 'instance creation' stamp: 'HernanWilkinson 7/13/2011 18:33'!
for: aValue

	^ self new initializeFor: aValue ! !


!classDefinition: #ReceptiveAccount category: 'ServiciosFinancieros-Ejercicio'!
Object subclass: #ReceptiveAccount
	instanceVariableNames: 'transactions'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'ServiciosFinancieros-Ejercicio'!

!ReceptiveAccount methodsFor: 'initialization' stamp: 'NR 10/17/2019 15:06:56'!
initialize

	transactions := OrderedCollection new.! !


!ReceptiveAccount methodsFor: 'main protocol' stamp: 'fp 11/21/2021 18:12:16'!
balance
	
	^transactions sum: [ :aTransaction | 
			aTransaction transactionValue 
	] ifEmpty:[0]
	! !

!ReceptiveAccount methodsFor: 'main protocol' stamp: 'NR 10/17/2019 03:28:43'!
hasRegistered: aTransaction

	^ transactions includes: aTransaction 
! !

!ReceptiveAccount methodsFor: 'main protocol' stamp: 'HernanWilkinson 7/13/2011 18:37'!
register: aTransaction

	transactions add: aTransaction 
! !

!ReceptiveAccount methodsFor: 'main protocol' stamp: 'fp 11/21/2021 17:57:53'!
transactions 

	^ transactions copy! !


!classDefinition: #Transfer category: 'ServiciosFinancieros-Ejercicio'!
Object subclass: #Transfer
	instanceVariableNames: 'deposit withdrawal'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'ServiciosFinancieros-Ejercicio'!

!Transfer methodsFor: 'as yet unclassified' stamp: 'fp 11/21/2021 17:50:09'!
deposit

	^deposit ! !

!Transfer methodsFor: 'as yet unclassified' stamp: 'fp 11/21/2021 18:13:33'!
initializeFrom: anOriginAccount to: aDestinationAccount for: anAmount

	deposit := Deposit register: anAmount on: aDestinationAccount.
	withdrawal := Withdraw register: anAmount on: anOriginAccount.
	
	deposit defineCounterparty: withdrawal.
	withdrawal defineCounterparty: deposit.! !

!Transfer methodsFor: 'as yet unclassified' stamp: 'fp 11/21/2021 17:50:12'!
withdrawal

	^withdrawal ! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'Transfer class' category: 'ServiciosFinancieros-Ejercicio'!
Transfer class
	instanceVariableNames: ''!

!Transfer class methodsFor: 'instance creation' stamp: 'fp 11/21/2021 18:04:54'!
from: anOriginAccount to: aDestinationAccount for: anAmount

 	(anAmount < 0) ifTrue:[
		self error: self negativeAmountErrorDescription.
	].
	
	^self new initializeFrom: anOriginAccount to: aDestinationAccount for: anAmount! !

!Transfer class methodsFor: 'instance creation' stamp: 'fp 11/19/2021 18:08:05'!
negativeAmountErrorDescription
	^'Amount is negative'! !
