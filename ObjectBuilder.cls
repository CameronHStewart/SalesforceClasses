public class ObjectBuilder {
    public static AccountRecordWrapper CreateAccount(String AccountName) {
     	Account accountRecord = new Account();
        accountRecord.Name = AccountName;
        
        AccountRecordWrapper ar = new AccountRecordWrapper(accountRecord);
        return ar; 
    }
    
    public static AccountRecordWrapper CreateContact(AccountRecordWrapper accountRecord) {
     	Contact contact = new Contact();
        contact.AccountId = accountRecord.account.Id;
        
        AccountRecordWrapper ar = new AccountRecordWrapper(contact);
        return ar; 
    }
    
    public static AccountRecordWrapper CreateAccountAndContact(String AccountName) {
     	Account account = CreateAccount(AccountName).account;
        
        insert account;
        account = [Select Id From Account Where Name = :AccountName Limit 1];
        
        Contact contactRecord = new Contact();
        contactRecord.AccountId = account.Id;
        
        AccountRecordWrapper ar = new AccountRecordWrapper(account);
        return ar;
    }
    
    public class AccountRecordWrapper {
     	public Account account; 
        public Contact contact;
        
        public AccountRecordWrapper(Account accountRec) {
            this.account = accountRec;
        }
        public AccountRecordWrapper(Contact contactRec) {
            this.contact = contactRec;
        }
        public AccountRecordWrapper(Account accountRec, Contact contactRec) {
            this.account = accountRec;
            this.contact = contactRec;
        }
    }
}