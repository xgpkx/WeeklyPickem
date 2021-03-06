import React, { Component } from 'react'
import { graphql, Mutation } from 'react-apollo'
import gql from 'graphql-tag'

import EmailIcon from 'mdi-react/EmailOutlineIcon';
import PasswordIcon from 'mdi-react/LockIcon';
import AccountIcon from 'mdi-react/AccountIcon';

import lcs_image from 'static/images/home_image3.jpg';

class RegisterForm extends Component {

    state = {
      name: "",
      email: "",
      emailConfirmation: "",
      password: "",
      passwordConfirmation: ""
    };

    render() {
      return (
        <Mutation mutation={CREATE_USER} errorPolicy="all">
          {(createUser, { loading, data, error }) => {
            
            return (
            <div className="container columns is-fluid registration-form">
              <div className="column is-two-fifths">
                <form>

                  <label className="label has-text-white">Display Name</label>
                  <div className="field">
                    <p className="control has-icons-left has-icons-right">
                      <input
                        className="input"
                        type="text"
                        placeholder="Display Name"
                        value={this.state.name}
                        onChange={e => this.setState({ name: e.target.value })}
                      />
                      <span className="icon is-small is-left">
                        <i className="fas fa-envelope"></i>
                      </span>
                      <span className="icon is-small is-left">
                        <AccountIcon />
                      </span>
                    </p>
                  </div>

                  <br />
                  <label className="label has-text-white">Email</label>
                  <div className="field">
                    <p className="control has-icons-left has-icons-right">
                      <input
                        className="input"
                        type="email"
                        placeholder="Email"
                        value={this.state.email}
                        onChange={e => this.setState({ email: e.target.value })}
                      />
                      <span className="icon is-small is-left">
                        <i className="fas fa-envelope"></i>
                      </span>
                      <span className="icon is-small is-left">
                        <EmailIcon />
                      </span>
                    </p>
                  </div>

                  <label className="label has-text-white">Email Confirmation</label>
                  <div className="field">
                    <p className="control has-icons-left has-icons-right">
                      <input
                        className="input"
                        type="email"
                        placeholder="Email Confirmation"
                        value={this.state.emailConfirmation}
                        onChange={e => this.setState({ emailConfirmation: e.target.value })}
                      />
                      <span className="icon is-small is-left">
                        <i className="fas fa-envelope"></i>
                      </span>
                      <span className="icon is-small is-left">
                        <EmailIcon />
                      </span>
                    </p>
                  </div>

                  <br />
                  <label className="label has-text-white">Password</label>
                  <div className="field">
                    <p className="control has-icons-left">
                      <input
                        className="input"
                        type="password"
                        placeholder="Password"
                        value={this.state.password}
                        onChange={e => this.setState({ password: e.target.value })}
                      />
                      <span className="icon is-small is-left">
                        <PasswordIcon />
                      </span>
                    </p>
                  </div>

                  <label className="label has-text-white">Password Confirmation</label>
                  <div className="field">
                    <p className="control has-icons-left">
                      <input
                        className="input"
                        type="password"
                        placeholder="Password Confirmation"
                        value={this.state.passwordConfirmation}
                        onChange={e => this.setState({ passwordConfirmation: e.target.value })}
                      />
                      <span className="icon is-small is-left">
                        <PasswordIcon />
                      </span>
                    </p>
                  </div>
                  <br />
                  { error &&
                    error.graphQLErrors.map(({ message }, i) => (
                      <div key={i} className="notification is-danger">{message}</div>
                    ))
                  }

                  { data && (<div className="notification is-success">Success! You can now login with your account.</div>)}

                  <div className="field is-grouped">
                    <div className="control">
                      <button type="submit" className="button is-link is-medium"
                        onClick={e => {
                          e.preventDefault()
                          const { name, email, emailConfirmation, password, passwordConfirmation } = this.state
                          createUser({ 
                            variables: { 
                              name: name,
                              email: email, 
                              emailConfirmation: emailConfirmation, 
                              password: password,
                              passwordConfirmation: passwordConfirmation 
                            }})
                          this.setState({ password: "" })
                          this.setState({ passwordConfirmation: "" })
                        }
                      }>
                      {loading ? <span className="loader"></span> : 'Signup'}
                    </button>
                  </div>
                  <div className="control">
                    <button className="button is-text is-medium has-text-white">Cancel</button>
                </div>
                </div>
              </form>
            </div>
            <div className="column">
              <figure className="image is-16by9">
                <img src={lcs_image} />
              </figure>
            </div>
          </div>
        )
      }}
      </Mutation>
    )
  }
};

const CREATE_USER = gql`
    mutation createUser (
      $name: String!,
      $email: String!,
      $emailConfirmation: String!,
      $password: String!,
      $passwordConfirmation: String!
    ) {
      createUser(
        name: $name, 
        email: $email, 
        emailConfirmation: $emailConfirmation,
        password: $password,
        passwordConfirmation: $passwordConfirmation
      ) {
        id,
        name
      }
    }
`

export default RegisterForm;
