defmodule WeeklyPickem.Web.Schema do
  use Absinthe.Schema

  import_types Absinthe.Type.Custom

  alias WeeklyPickem.Web.Resolvers

  @desc "Non-match specific team data"
  object :team_data do
    field :id, non_null(:id)
    field :name, non_null(:string)
    field :acronym, non_null(:string)
    field :stats, non_null(:team_stats)
  end

  @desc "Relevant team data for match"
  object :match_team do
    field :data, non_null(:team_data)
    field :is_pick, non_null(:boolean)
    field :is_winner, :boolean
  end

  @desc "Match with embeded relevant"
  object :match do
    field :id, non_null(:id)
    field :time, non_null(:datetime)
    field :team_one, non_null(:match_team)
    field :team_two, non_null(:match_team)
  end

  @desc "Series of Matches, e.g. Season/Tourney"
  object :series do
    field :id, non_null(:id)
    field :name, non_null(:string)
    field :start_at, non_null(:datetime)
    field :matches, list_of(:match)
    field :pick_stats, :user_pick_stats
  end

  @desc "Submit-only object for choosing picks"
  object :pick do
    field :team_id, non_null(:id)
    field :match_id, non_null(:id)
  end

  @desc "User Correct/Wrong Stats for Picks"
  object :user_pick_stats do
    field :id, non_null(:id)
    field :correct, non_null(:integer)
    field :total, non_null(:integer)
  end

  @desc "Win/Loss Stats for Team"
  object :team_stats do
    field :id, non_null(:id)
    field :wins, non_null(:integer)
    field :total, non_null(:integer)
  end

  @desc "User ID Only"
  object :user_id do
    field :id, non_null(:string)
  end

  @desc "Simple user object with id, name and email"
  object :current_user do
    field :id, non_null(:string)
    field :name, :string
    field :email, :string
  end

  @desc "Public user profile"
  object :public_user_profile do
    field :id, non_null(:id)
    field :name, non_null(:string)
    field :stats, list_of(:user_pick_stats)
  end

  @desc "Access token, used for authenticating API calls"
  object :access_token do
    field :token, non_null(:string)
  end

  @desc "Refresh token, used for getting new Access Tokens"
  object :refresh_token do
    field :token, non_null(:string)
    field :expiration, non_null(:integer)
  end

  @desc "Login object with refresher and access token with additional user object"
  object :login do
    field :refresh_token, non_null(:refresh_token)
    field :access_token, non_null(:access_token)
    field :user, non_null(:current_user)
  end

  @desc "Logout user by supplying a corresponding refresh token"
  object :logout do
    field :message, non_null(:string)
  end

  query do
    field :all_teams, list_of(non_null(:team_data)) do
      resolve &Resolvers.TeamResolver.all_teams/3
    end

    @desc "Return current user id"
    field :current_user, :user_id do
      resolve &Resolvers.UserResolver.current_user_id/3  
    end
    
    @desc "Return current user's profile"
    field :current_user_profile, :current_user do
      resolve &Resolvers.UserResolver.current_user_profile/3  
    end

    @desc "Return a series with all relevant matches"
    field :get_series, :series do
      arg :series_tag, non_null(:string)
      resolve &Resolvers.MatchResolver.get_series/3
    end

    @desc ""
    field :get_series_user_stats, list_of(:public_user_profile) do
      arg :series_tag, non_null(:string)
      resolve &Resolvers.UserResolver.get_series_user_stats/3
    end

  end

  mutation do
    @desc "Login an existing user"
    field :login_user, :login do
      arg :email, non_null(:string)
      arg :password, non_null(:string)

      resolve &Resolvers.UserResolver.login_user/3
    end

    @desc "Refresh access token with an refresh token"
    field :refresh_access, :access_token do
      arg :refresh_token, non_null(:string)

      resolve &Resolvers.UserResolver.refresh_access/3
    end

    @desc "Logout the user with the refresh token"
    field :logout_user, :logout do
      arg :refresh_token, non_null(:string)

      resolve &Resolvers.UserResolver.logout_user/3
    end

    @desc "Create a new user"
    field :create_user, :current_user do
      arg :name, non_null(:string)
      arg :email, non_null(:string)
      arg :email_confirmation, non_null(:string)
      arg :password, non_null(:string)
      arg :password_confirmation, non_null(:string)

      resolve &Resolvers.UserResolver.create_user/3
    end

    @desc "Submitted User Pick"
    field :submit_user_pick, :pick do
      arg :match_id, non_null(:id)
      arg :team_id, non_null(:id)
      arg :team_name, :string #Kinda just for debug capability

      resolve &Resolvers.PickResolver.submit_user_pick/3
    end
  end

end
