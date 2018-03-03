import React, { Component } from 'react';
import Redirect from 'react-router';
import { graphql } from 'react-apollo'
import gql from 'graphql-tag'

import EmailIcon from 'mdi-react/EmailOutlineIcon';
import PasswordIcon from 'mdi-react/LockIcon';

class LoginForm extends Component {

  state = {
    email: "",
    password: ""
  };

  render() {


    return (
      <div className="container is-fluid login-form">
        <form>
        <span className="title is-4 has-text-white"> Login </span>

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


        <div className="field">
          <p className="control">
            <button type="submit" className="button is-link" onClick={e => this._loginUser(e)}>
              Login
            </button>
          </p>
        </div>
      </form>
      </div>
    );
  }

  _loginUser = async event => {
    event.preventDefault();
    const { email, password } = this.state

    // Clear password input field
    this.setState({ password: "" })

    const result = await this.props.loginMutation({
      variables: {
        email,
        password
      }
    })

    if (result.data.loginUser) {
      const refreshToken = result.data.loginUser.refreshToken.token
      const accessToken = result.data.loginUser.accessToken.token

      this._saveUserData(refreshToken, accessToken)
    }
  }

  _saveUserData = (refreshToken, accessToken) => {
    localStorage.setItem("refresh-token", refreshToken)
    localStorage.setItem("access-token", accessToken)
  }
}


const LOGIN_MUTATION = gql`
    mutation loginMutation($email: String!, $password: String!) {
      loginUser(email: $email, password: $password) {
        refreshToken {
          token
          expiration
        }
        accessToken {
          token
        }
        user {
          id
          name
          email
        }
      }
  }
`

export default graphql(LOGIN_MUTATION, {
  name: "loginMutation",
  options: {
    errorPolicy: "all"
  } })(LoginForm)
