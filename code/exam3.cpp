#include <iostream>
using namespace std;

int countnumber = 0;
int ww = 1;
int counting = 0;
bool EXPR();
bool TERM1();
bool VAL1();
bool SIG1();
struct token
{
    string type;
    string value;
    token* next = NULL;
};

token* token_start;
token* token_end;
token* temptoken;

token* expandtoken()
{
    token* tok = new token;
    if(token_start == NULL)
    {
        token_start = tok;
        token_end = tok;
    }
    else
    {
        token_end->next = tok;
        token_end = tok;
    }
    countnumber+=1;
    return tok;
}

void scanner(string temp)
{
    token* toke;
    bool point = false;
    if(temp.size()==1)
    {
        if(temp[0]=='+'||temp[0]=='-'||temp[0]=='*'||temp[0]=='/')
        {
            toke = expandtoken();
            toke->type = "op";
            toke->value = temp;
        }
        else if(temp[0]>='0'&&temp[0]<='9')
        {
            toke = expandtoken();
            toke->type = "num";
            toke->value = temp;
        }
        else if(temp[0]=='(')
        {
            toke = expandtoken();
            toke->type = "lparenthesis";
            toke->value = temp;
        }
        else if(temp[0]==')')
        {
            toke = expandtoken();
            toke->type = "rparenthesis";
            toke->value = temp;
        }
        else
        {
            toke = expandtoken();
            toke->type = "error";
            toke->value = temp;
        }
    }
    else
    {
        string numstring;
        for(int i = 0 ; i < temp.size() ; i++)
        {
            if(temp[i]=='0')
            {
                numstring += temp[i];
                i+=1;
                if(temp[i]==')')
                {
                    toke = expandtoken();
                    toke->type = "num";
                    toke->value = numstring;
                    numstring = "";
                    toke = expandtoken();
                    toke->type = "rparenthesis";
                    toke->value = temp[i];
                    i+=1;
                }
                else if(temp[i]=='.')
                {
                    numstring += temp[i];
                    i+=1;
                    while((temp[i]>='0'&&temp[i]<='9')||temp[i]==')')
                    {
                        if(i == temp.size()-1)
                        {
                            if(temp[i]>='0'&&temp[i]<='9')
                            {
                                numstring += temp[i];
                                toke = expandtoken();
                                toke->type = "num";
                                toke->value = numstring;
                                numstring = "";
                                break;
                            }
                            else if(temp[i]==')'&&(temp[i-1]>='0'&&temp[i-1]<='9'))
                            {
                                toke = expandtoken();
                                toke->type = "num";
                                toke->value = numstring;
                                numstring = "";
                                toke = expandtoken();
                                toke->type = "rparenthesis";
                                toke->value = temp[i];
                                break;
                            }
                            else if(temp[i]==')'&&temp[i-1]==')')
                            {
                                toke = expandtoken();
                                toke->type = "rparenthesis";
                                toke->value = temp[i];
                                break;
                            }
                            else
                            {
                                numstring += temp[i];
                                toke = expandtoken();
                                toke->type = "error";
                                toke->value = numstring;
                                numstring = "";
                                break;
                            }
                        }
                        else if(temp[i]>='0'&&temp[i]<='9')
                        {
                            numstring += temp[i];
                            i+=1;
                        }
                        else if(temp[i]==')'&&(temp[i-1]>='0'&&temp[i-1]<='9'))
                        {
                            toke = expandtoken();
                            toke->type = "num";
                            toke->value = numstring;
                            numstring = "";
                            toke = expandtoken();
                            toke->type = "rparenthesis";
                            toke->value = temp[i];
                            i+=1;
                        }
                        else if(temp[i]==')'&&temp[i-1]==')')
                        {
                            toke = expandtoken();
                            toke->type = "rparenthesis";
                            toke->value = temp[i];
                            i+=1;
                            break;
                        }
                        else
                        {
                            numstring += temp[i];
                            toke = expandtoken();
                            toke->type = "error";
                            toke->value = numstring;
                            numstring = "";
                            i+=1;
                            break;
                        }
                    }
                }
                else
                {
                    numstring += temp[i];
                    toke = expandtoken();
                    toke->type = "error";
                    toke->value = numstring;
                    numstring = "";
                    i+=1;
                }
            }
            else if(temp[i]>='1'&&temp[i]<='9')
            {
                numstring += temp[i];
                i+=1;
                if(i == temp.size())
                {
                    toke = expandtoken();
                    toke->type = "num";
                    toke->value = numstring;
                    numstring = "";
                }
                if((temp[i]<'0'||temp[i]>'9')&&temp[i]!=')'&&temp[i]!='.'&&i<temp.size())
                {
                    numstring += temp[i];
                    i+=1;
                    toke = expandtoken();
                    toke->type = "error";
                    toke->value = numstring;
                    numstring = "";
                }
                while((temp[i]>='0'&&temp[i]<='9')||temp[i]==')'||temp[i]=='.')
                {
                    if(i == temp.size()-1)
                    {
                        if(temp[i]>='0'&&temp[i]<='9')
                        {
                            numstring += temp[i];
                            toke = expandtoken();
                            toke->type = "num";
                            toke->value = numstring;
                            numstring = "";
                            break;
                        }
                        else if(temp[i]==')'&&(temp[i-1]>='0'&&temp[i-1]<='9'))
                        {
                            toke = expandtoken();
                            toke->type = "num";
                            toke->value = numstring;
                            numstring = "";
                            toke = expandtoken();
                            toke->type = "rparenthesis";
                            toke->value = temp[i];
                            break;
                        }
                        else if(temp[i]==')'&&temp[i-1]==')')
                        {
                            toke = expandtoken();
                            toke->type = "rparenthesis";
                            toke->value = temp[i];
                            break;
                        }
                        else
                        {
                            numstring += temp[i];
                            toke = expandtoken();
                            toke->type = "error";
                            toke->value = numstring;
                            numstring = "";
                            break;
                        }
                    }
                    else if(temp[i]=='.'&&point==false)
                    {
                        numstring+=temp[i];
                        i += 1;
                        point = true;
                    }
                    else if(temp[i]>='0'&&temp[i]<='9')
                    {
                        numstring += temp[i];
                        i+=1;
                    }
                    else if(temp[i]==')'&&(temp[i-1]>='0'&&temp[i-1]<='9'))
                    {
                        toke = expandtoken();
                        toke->type = "num";
                        toke->value = numstring;
                        numstring = "";
                        toke = expandtoken();
                        toke->type = "rparenthesis";
                        toke->value = temp[i];
                        i+=1;
                    }
                    else if(temp[i]==')'&&temp[i-1]==')')
                    {
                        toke = expandtoken();
                        toke->type = "rparenthesis";
                        toke->value = temp[i];
                        break;
                    }
                    else
                    {
                        numstring += temp[i];
                        toke = expandtoken();
                        toke->type = "error";
                        toke->value = numstring;
                        numstring = "";
                        i+=1;
                        break;
                    }
                }
            }
            else if(temp[i]=='+'||temp[i]=='-')
            {
                toke = expandtoken();
                toke->type = "sign";
                toke->value = temp[i];
            }
            else if(temp[i]=='(')
            {
                toke = expandtoken();
                toke->type = "lparenthesis";
                toke->value = temp[i];
            }
            else if(temp[i]==')')
            {
                toke = expandtoken();
                toke->type = "rparenthesis";
                toke->value = temp[i];
            }
            else
            {
                toke = expandtoken();
                toke->type = "error";
                toke->value = temp[i];
            }
            if(i >= temp.size())
            {
                break;
            }
        }
    }
}

bool SIG1()
{
    if(temptoken->type == "sign")
    {
        counting +=1;
        temptoken = temptoken->next;
        return true;
    }
    else

    {
        return true;
    }
}
bool VAL1()
{
    bool checkval = true;
    if(temptoken->type == "num")
    {
        counting += 1;
        temptoken = temptoken->next;
        return true;
    }
    else if(temptoken->type=="lparenthesis")
    {
        //cout << "1"  << temptoken->type << endl;;
        counting += 1;
        temptoken = temptoken->next;
        checkval = EXPR();
        //cout << "2"  << " " << temptoken->type << " " << checkval;
        if(temptoken->type=="rparenthesis"&&checkval)
        {
            counting += 1;
            temptoken = temptoken->next;
            return true;
        }
        else
        {
            return false;
        }
    }
    else
    {
        checkval = false;
        return checkval;
    }
}
bool TERM1()
{
    if(counting == countnumber)
    {
        return true;
    }
    else if(counting < countnumber)
    {
        bool checktrerm = true;
        if(temptoken->type == "op")
        {
            counting+=1;
            temptoken = temptoken->next;
            checktrerm = SIG1();
            checktrerm = VAL1();
            checktrerm = TERM1();
            return checktrerm;
        }
        else if(temptoken->type=="rparenthesis")
        {
            return true;
        }
        else
        {
            return false;
        }
    }

}


bool EXPR()
{
    bool check = true;
    check = SIG1();
    if(check == false)
    {
        return false;
    }
    check = VAL1();
    if(check == false)
    {
        return false;
    }

    check = TERM1();
    if(check == false)
    {
        check = false;
    }

    return check;
}

int main()
{
    bool checker = true;
    countnumber = 0;
    counting = 0;
    token_start = NULL;
    token_end = NULL;
    string input;

    while(cin >> input)
    {
        if(input == "-1")
        {
            break;
        }
        scanner(input);
    }
    temptoken = token_start;
    checker = EXPR();
    if(checker)
    {
        cout << token_start->type << " " << token_start->value << endl;
        for(int i = 0 ; i < countnumber-1 ; i++)
        {
            token_start = token_start->next;
            cout << token_start->type << " " << token_start->value << endl;
        }
    }
    else
    {
        cout << "invalid input" << endl;
    }
    return 0;
}
