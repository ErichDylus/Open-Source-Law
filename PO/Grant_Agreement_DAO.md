CodersNote=From GitHub.com/ErichDylus/Open-Source-Law

CodersNote=Parameters from original:

ContractLife.Stop.AtWill.NoticePeriod.cl=thirty (30) calendar days’

Comp.Monthly.Amount.$=USD$[______]

Law.State.the=the State of Delaware

LawyersNote="MIT Creative Commons license" seems to mix two things.

LawyersNote="Term" is used but not defined.

// simple agreement contemplating DAO treasury grants (by DAO legal wrapper) for independent contractor services, adaptable for individuals or entities

// effective date should correspond to commencement of applicable DAO grant cycle

// provided without warranty of any kind, do not use without consulting an attorney, all open-source-law repo disclosures apply

Doc.Ti=Grant Agreement

This.sec=This Grant Agreement (this “{Def.Agreement.Target}”) is entered into as of {EffectiveDate.YMD} (the “Effective Date”) by and between {P1.US.N,E,A} (“{Def.Service_Provider.Target}”) and {P2.US.N,E,A} (the “{Def.DAO_Legal_Entity.Target}”), represented and governed by the {DAO.Name.Full} Decentralized Autonomous Organization associated with address {DAO.BlockchainAddress} (“{Def.DAO.Target}”) ({_DAO} and the {_DAO_Legal_Entity}, together with any and all subsidiaries and affiliates, “{Def.DAO_Party.Target}”) ({_Service_Provider} and {_DAO_Party} are each a “{Def.Party.Target}” and both, the “{_Parties}”).

Why.sec={_DAO_Party} has deemed that {_Service_Provider} has the necessary qualifications, experience, and abilities to provide {_Services} (as such term is defined in Section {Service.Xnum} below) to and for the benefit of {_DAO_Party}, and {_Service_Provider} has agreed to provide such {_Services} to and for the benefit of {_DAO_Party} pursuant to the terms and conditions set forth in this {_Agreement}, with {_Service_Provider} to be deemed an independent contractor for {_DAO_Party} (as more particularly set forth in Section {IndependentContractor.Xnum} below, the “{Def.Relationship.Target}”). 

Then.sec=In consideration of the mutual benefits and obligations set forth in this {_Agreement}, the receipt and sufficiency of which is hereby acknowledged, {_Service_Provider} and {_DAO_Party} agree as follows:

Service.Ti=Services

Service.sec={_DAO_Party} hereby engages {_Service_Provider} to provide {_DAO_Party} or its written designee with the following services: {Services.Description.cl} (including any other services reasonably related thereto and/or as mutually agreed in writing between the {_Parties}, the “{Def.Services.Target}”).

Service.=[G/Z/Base]

Term.Ti=Term

Term.1.sec=The term of this {_Agreement} commences on the Effective Date and remains in full force and effect (except for the terms of this {_Agreement} which expressly survive the expiry or termination of this {_Agreement}) until {Term.End.sec} or until terminated pursuant to the terms of this {_Agreement}.

Term.End.=[G/Z/Alt/2]

Term.End.SecName=Term.End


Term.End.AltPrompt=Select "FixedDate" or "Milestone".

Term.End.Alt1.sec={Term.End.FixedDate.sec}

Term.End.FixedDate.sec={Term.End.FixedDate.YMD}

Term.End.Alt2.sec={Term.End.Milestone.sec}

Term.End.Milestone.sec=milestone completion (as confirmed in writing by {_DAO_Party}) of {Work.Milestone.Description.cl}

Term.2.sec=This {_Agreement} may be terminated in writing upon {ContractLife.Stop.AtWill.NoticePeriod.cl}' prior written notice by either {_Party}, or by mutual written agreement of the {_Parties}. However, notwithstanding the foregoing sentence, if {_Service_Provider} has been provided written notice from {_DAO_Party} as to any material issue with the quality or provision of the {_Services} which remains uncured for ten days in {_DAO_Party}’s sole reasonable discretion, this {_Agreement} may be terminated immediately by written notice from {_DAO_Party}.

Term.3.sec=For avoidance of doubt, this {_Agreement} may be terminated in accordance with this section at any point in a calendar month or compensation cycle, and {_Service_Provider}’s compensation for such calendar month or compensation cycle shall be reduced or prorated accordingly to match the actual number of days providing {_Services} for such calendar month or compensation cycle, as applicable.

Term.=[G/Z/ol-a/s3]

Compensate.Ti=Compensation

Compensate.1.sec=For each calendar month in the Term, {_DAO_Party} or its written designee will pay {_Service_Provider} an equivalent amount to {Comp.Monthly.Amount.$} by {Stablecoin.Name} or other mutually agreed payment method and calculation within the first calendar week of each applicable month or as otherwise mutually agreed in writing.

Compensate.2.sec={_DAO_Party} will reimburse {_Service_Provider} for all reasonable and necessary expenses incurred by {_Service_Provider} directly attributable to the {_Services}, subject to {_DAO_Party}’s express prior written approval of such expenses. 

Compensate.=[G/Z/ol-a/s2]

IndependentContractor.Ti=Independent Contractor Relationship

IndependentContractor.sec=In providing the {_Services} under this {_Agreement}, the {_Parties} expressly agree that {_Service_Provider} is acting as an independent contractor and not as an employee or agent of {_DAO_Legal_Entity}, {_DAO_Party} or any other related entity. {_Service_Provider} and {_DAO_Party} acknowledge and agree that this {_Agreement} does not create a partnership of any kind, nor any joint venture or similar relationship, and is exclusively a contract for service. {_Service_Provider} is not required to pay or make any contributions of any monetary value towards any governmental entity for tax purposes, unemployment compensation, worker’s compensation, insurance premium, pension or any other employee benefit with respect to {_DAO_Party} during the Term. {_Service_Provider} acknowledges and agrees that {_Service_Provider} is solely responsible for complying with all laws, regulations, and other governmental requirements applicable to {_Service_Provider} including but not limited to paying all taxes, expenses, and other amounts due from {_Service_Provider} of any kind related to this {_Agreement}.

IndependentContractor.=[G/Z/Base]

// applicable for where grantee will be privy to confidential information, such as information subject to a third party's NDA, or perhaps where a grantee wishes to preserve their own anonymity, etc.

ConfInfo.Ti=Confidential Information

ConfInfo.General.sec=Each {_Party}, their respective affiliates and their respective directors, officers, employers, employees, agents, members, or advisors (collectively, “{Def.Representatives.Target}”) may be alerted of, become privy to, or gain access to certain confidential and/or proprietary information of the other {_Party}. A {_Party} or its {_Representative} disclosing its {_Confidential_Information} (as such term is defined in Section {ConfInfo.Except.Xnum} below) to the other {_Party} is hereafter referred to as a “{Def.Disclosing_Party.Target}.” A {_Party} or its {_Representative} receiving the {_Confidential_Information} of the {_Disclosing_Party} is hereafter referred to as a “{Def.Receiving_Party.Target}.”

ConfInfo.Def.1.sec=The term “{Def.Confidential_Information.Target}” as used in this {_Agreement} shall mean any data or information that is reasonably sensitive material and not generally known to the public or any third parties, including, but not limited to, information relating to any of the following: the {_Relationship}, product development and plans, proprietary concepts, documentation, operations, systems, computer software, source code, trade secrets, customer lists, customer relationships, negotiations, present or future business activities, design, verbal conversations or representations, writings, technical information and details which the {_Disclosing_Party} reasonably considers confidential, and anything {_DAO_Party} sets forth in writing as being confidential or sensitive material.

CodersNote=Optional:

ConfInfo.Def.2.sec=Unless expressly set forth in writing otherwise, any and all data, information, correspondence, materials, activities, operations, or relationships in any way related to “{Conf.CoreSubject.cl}” or any reference thereof shall be deemed included in the definition of “{_Confidential_Information}.”

ConfInfo.Def.=[G/Z/para/s2]

ConfInfo.Except.sec=The obligation of confidentiality with respect to {_Confidential_Information} will not apply to any information publicly known or accessible due to prior authorized or lawful disclosure, or if the information is disclosed by the {_Receiving_Party} with the {_Disclosing_Party}’s prior written consent and approval.

ConfInfo.Engage.0.sec=With respect to {_Confidential_Information}: 

ConfInfo.Engage.1.sec={_Receiving_Party} and its {_Representatives} agree to retain the {_Confidential_Information} of the {_Disclosing_Party} in strict confidence, to protect the security, integrity and confidentiality of such information and to not permit unauthorized access to or unauthorized use, disclosure, publication or dissemination of {_Confidential_Information} except in conformity with this {_Agreement};
  
ConfInfo.Engage.2.sec={_Receiving_Party} and its {_Representatives} shall adopt and/or maintain security processes and procedures to safeguard the confidentiality of all {_Confidential_Information} received by {_Disclosing_Party} using a reasonable degree of care, but not less than that degree of care used in safeguarding its own similar information or material;
  
ConfInfo.Engage.3.sec=Upon termination the termination of this {_Agreement}, {_Receiving_Party} will ensure that all documents, writings, and other electronic records that include or reflect any {_Confidential_Information} are returned to {_Disclosing_Party} or are destroyed as directed by {_Disclosing_Party};
  
ConfInfo.Engage.4.sec=If there is an unauthorized disclosure or loss of any of the {_Confidential_Information} by {_Receiving_Party} or any of its {_Representatives}, {_Receiving_Party} will promptly, at its own expense, notify {_Disclosing_Party} in writing and take all actions as may be necessary or reasonably requested by {_Disclosing_Party} to minimize any damage to the {_Disclosing_Party} or a third party as a result of the disclosure or loss; and 
  
ConfInfo.Engage.5.sec=The obligation not to disclose {_Confidential_Information} shall survive the termination of this {_Agreement}, and at no time will {_Receiving_Party} or any of its {_Representatives} be permitted to disclose {_Confidential_Information}, except to the extent that such {_Confidential_Information} is excluded from the obligations of confidentiality under this {_Agreement} pursuant to Section {ConfInfo.Except.Xnum} above.

ConfInfo.Engage.=[G/Z/ol-i/s5]

ConfInfo.sec=<ol type="a"><li>{ConfInfo.General.sec}</li><li>{ConfInfo.Def.sec}</li><li>{ConfInfo.Except.sec}</li><li>{ConfInfo.Engage.sec}</li></ol>

ConfInfo.=[G/Z/Base]

License.OpenSource.Ti=Open Source

License.OpenSource.sec=The {_Parties} acknowledge and agree that all work product and materials from the {_Services}, unless expressly agreed in writing to the contrary, are and will be made and distributed under the MIT Creative Commons license.

License.OpenSource.=[G/Z/Base]

License.WorkForHire.Ti=Ownership of Intellectual Property

License.WorkForHire.sec=All intellectual property, work product, and related material including any trade secrets, moral rights, goodwill, relevant registrations or applications for registration, and rights in any patent, copyright, trademark, trade dress, industrial design, non-open source software, method, trade name and communications (the “{Def.Intellectual_Property.Target}”) that is developed, progressed, or produced under this {_Agreement} is a “work made for hire” and will be the sole property of {_DAO_Party}. {_Service_Provider} may not use the {_Intellectual_Property} for any purpose other than as agreed herein except with the prior written consent of {_DAO_Party}. The use of the {_Intellectual_Property} by {_DAO_Party} will not be restricted in any manner. {_Service_Provider} will be responsible for any and all damages resulting from {_Service_Provider}’s or its {_Representatives}’ or a third party’s (to the extent such third party received or became aware of {_Intellectual_Property} from {_Service_Provider}) unauthorized use of the {_Intellectual_Property}.

License.WorkForHire.=[G/Z/Base]

License.Sec=<span class="alt">Choose One: License.Sec=&lbrace;License.OpenSource.Sec&rbrace; or Sec.6=&lbrace;License.WorkForHire.Sec&rbrace;<ol><li>{License.OpenSource.Sec}</li><li>{License.WorkForHire.Sec}</li></ol></span>

Remedy.Ti=Remedies and Indemnity

Remedy.1.sec=Each {_Party} agrees that use or disclosure of any {_Confidential_Information} [or {_Intellectual_Property}] in a manner inconsistent with this {_Agreement} will give rise to irreparable injury for which: (i) money damages may not be a sufficient remedy for any breach of this {_Agreement} by such {_Party}; (ii) the other {_Party} may be entitled to specific performance and injunction and other equitable relief with respect to any such breach; (iii) such remedies will not be the exclusive remedies for any such breach, but will be in addition to all other remedies available at law or in equity; and (iv) in the event of litigation relating to this {_Agreement}, if a court of competent jurisdiction determines in a final non-appealable order that one {_Party} or any of its {_Representatives} has breached this {_Agreement}, such {_Party} will be liable for reasonable legal fees and expenses incurred by the other {_Party} in connection with such litigation.

Remedy.2.sec=Each {_Party} agrees to defend, indemnify and hold harmless the other {_Party} against any and all liabilities, claims, suits, losses, damages and expenses, including reasonable attorney's fees, incurred by or asserted against the indemnified {_Party} to the extent caused by the acts or omissions of the indemnifying {_Party} in connection with the performance of {_Services} under this {_Agreement}. 

Remedy.3.sec={_DAO_Legal_Entity} hereby acknowledges and agrees that {_Service_Provider} has made no express warranties concerning the {_Services}.  It is solely Entity’s responsibility to determine whether the {_Services} will suit {_DAO_Party}’s needs or goals. <span style="text-transform: uppercase">The {_Services} are provided "as is" without warranty of any kind.  {_DAO_Legal_Entity}, to the fullest extent permitted by law, hereby disclaims and {_DAO_Legal_Entity} hereby waives all warranties by {_Service_Provider}, including, but not limited to, all implied warranties of fitness for a particular purpose, all implied warranties of merchantability and warranties of non-infringement of third party rights in connection with the {_Services}. {_Service_Provider} does not warrant, and {_DAO_Legal_Entity} hereby waives any warranty, that the {_Services} will yield any particular results or successful outcomes.  {_Service_Provider} does not make any warranty and {_DAO_Legal_Entity} hereby waives any and all warranties as to the results obtained from the {_Services}.<span>
 
Remedy.4.sec=<span style="text-transform: uppercase">Limitation of liability: {_Service_Provider} shall not be liable for any lost profits or consequential, exemplary, incidental or punitive damages (including, without limitation, in connection with the {_Services} provided hereunder, regardless of the form of action, whether in contract or in tort, including negligence, and regardless of whether such damages are reasonably foreseeable.</span>

Remedy.=[G/Z/ol-a/s4]

Assign.Ti=Assignment

Assign.sec=Neither {_Party} will voluntarily, or by operation of law, assign or otherwise transfer its obligations under this {_Agreement} without the prior written consent of the other {_Party}. 

Assign.=[G/Z/Base]

Notice.Ti=Notices

Notice.sec=All notices given under this {_Agreement} shall be in writing and provided in the same manner and to the same addresses and addressees as the {_Agreement} itself or as otherwise designated in writing by the {_Parties}.

Notice.=[G/Z/Base]

Amend.Ti=Amendment

Amend.sec=This {_Agreement} may be amended or modified only by a written agreement signed by both {_Parties}.

Amend.=[G/Z/Base]

Law.Ti=Jurisdiction

Law.sec=This {_Agreement} will be governed by and construed in accordance with the laws of {Law.State.the}, without regard to the principles of conflict of laws. 

Law.=[G/Z/Base]

Misc.Ti=Miscellaneous

Misc.1.sec=This {_Agreement} will inure to the benefit of and be binding on the respective successors and permitted assigns of the {_Parties}. 

Misc.2.sec=The waiver by either {_Party} of a breach, default, delay or omission of any of the provisions of this {_Agreement} by the other {_Party} will not be construed as a waiver of any subsequent breach of the same or any other provision.

Misc.3.sec=Neither {_Party} shall be in default or otherwise liable for any delay in, or failure of its performance under this {_Agreement}, where such delay or failure arises by reason of any Act of God, or of any government or any governmental body, any material bug, defect or error in any of the {_DAO_Party} code, framework or interface or any smart contract or third party oracle or storage program, network or layer or other infrastructure on which the {_DAO_Party} code is reliant, or the unauthorized triggering, use or exploitation (whether intentional or unintentional) of any of the foregoing which renders {_Service_Provider} reasonably unable to provide the {_Services}, or other cause beyond the control of the {_Parties} (any of the foregoing, a “force majeure”); provided, however, that the delay or failure in performance could not have reasonably been foreseen or provided against; and provided further that each {_Party} exercises such diligence in resolving the force majeure as the circumstances may require.

Misc.4.sec=If any provision of this {_Agreement} is held to be invalid, illegal or unenforceable in whole or in part, the remaining provisions shall not be affected and shall continue to be valid, legal and enforceable as though the invalid, illegal or unenforceable parts were severed from this {_Agreement}.

Misc.5.sec=This {_Agreement} may be executed in counterparts, each of which shall be deemed an original, but both of which together shall constitute one and the same instrument. This {_Agreement} may be executed by commercially acceptable electronic means, and any electronic signatures to this {_Agreement} are the same as handwritten signatures for purposes of validity, enforceability, and admissibility.

Misc.=[G/Z/ol-a/s5]

sec=<ol><li>{Service.Sec}</li><li>{Term.Sec}</li><li>{Compensate.Sec}</li><li>{IndependentContractor.Sec}</li><li>{ConfInfo.Sec}</li><li>{License.Sec}</li><li>{Remedy.Sec}</li><li>{Assign.Sec}</li><li>{Notice.Sec}</li><li>{Amend.Sec}</li><li>{Law.Sec}</li><li>{Misc.Sec}</li></ol>

=[G/Agt-Form-CmA/US/0.md]

*****************************************************



The Parties hereto have executed this Agreement as of the Effective Date.



[PARTY A SIGNATURE]
By: 
**[Party A]
Ethereum Address: ________________________**



[DAO SIGNATURE]
By: 
**[DAO LEGAL WRAPPER]**

CodersNote=Defined Terms and other parameters:

_DAO=<a href='#Def.DAO.Target' class='definedterm'>DAO</a>

_DAO_Legal_Entity=<a href='#Def.DAO_Legal_Entity.Target' class='definedterm'>DAO Legal Entity</a>

_Service_Provider=<a href='#Def.Service_Provider.Target' class='definedterm'>Service Provider</a>

_DAO_Party=<a href='#Def.DAO_Party.Target' class='definedterm'>DAO Party</a>

_Representative=<a href='#Def.Representatives.Target' class='definedterm'>Representative</a>

_Relationship=<a href='#Def.Relationship.Target' class='definedterm'>Relationship</a>

_Representatives=<a href='#Def.Representatives.Target' class='definedterm'>Representatives</a>

_Intellectual_Property=<a href='#Def.Intellectual_Property.Target' class='definedterm'>Intellectual Property</a>

Def.Agreement.Target={_Agreement}

Def.Service_Provider.Target={_Service_Provider}

Def.DAO_Legal_Entity.Target={_DAO_Legal_Entity}

Def.DAO.Target={_DAO}

Def.DAO_Party.Target={_DAO_Party}

Def.Party.Target={_Party}

Def.Relationship.Target={_Relationship}

Def.Services.Target={_Services}

Def.Representatives.Target={_Representatives}

Def.Disclosing_Party.Target={_Disclosing_Party}

Def.Receiving_Party.Target={_Receiving_Party}

Def.Confidential_Information.Target={_Confidential_Information}

Def.Intellectual_Property.Target={_Intellectual_Property}

CodersNote=Parameterized Section Cross-references.

Service.Xnum=<a href="#Service.Sec">1</a>

ConfInfo.Xnum=<a href="#ConfInfo.Sec">5</a>

ConfInfo.Except.Xnum={ConfInfo.Xnum}.<a href="#ConfInfo.Except.sec">c</a>

IndependentContractor.Xnum=<a href='#IndependentContractor.Sec'>4</a>

_P1={_Service_Provider}

_P2={_DAO_Party}
