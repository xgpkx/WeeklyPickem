# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     WeeklyPickem.Repo.insert!(%WeeklyPickem.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias WeeklyPickem.Repo

alias WeeklyPickem.Model.User
alias WeeklyPickem.Model.Team
alias WeeklyPickem.Model.Match
alias WeeklyPickem.Model.Pick

# "password"
fake_password = "$argon2i$v=19$m=65536,t=6,p=1$ZoHzGFWK98QZl3chJeAqgg$jPWznqwlqrV0QPQ+ZfFAqZtAVHEMArb310ntjvV2EsY"

%User{name: "Sam Garvis", email: "sam@garvis.com", password: fake_password} |> Repo.insert!
%User{name: "Ben Milks", email: "ben@milks.com", password: fake_password} |> Repo.insert!
%User{name: "Dan Dan", email: "dan@dan.com", password: fake_password} |> Repo.insert!

%Team{name: "Team Solo Mid", acronym: "TSM", region: "NA"} |> Repo.insert!
%Team{name: "Counter Logic Gaming", acronym: "CLG", region: "NA"} |> Repo.insert!
%Team{name: "100 Thieves", acronym: "100", region: "NA"} |> Repo.insert!

%Match{cutoff: DateTime.utc_now(), time: DateTime.utc_now(), team_one: 1, team_two: 2} |> Repo.insert!
%Match{cutoff: DateTime.utc_now(), time: DateTime.utc_now(), team_one: 1, team_two: 3} |> Repo.insert!
%Match{cutoff: DateTime.utc_now(), time: DateTime.utc_now(), team_one: 3, team_two: 2} |> Repo.insert!

%Pick{user_id: 1, match_id: 1, team_id: 1} |> Repo.insert!
%Pick{user_id: 2, match_id: 2, team_id: 3} |> Repo.insert!
%Pick{user_id: 3, match_id: 3, team_id: 2} |> Repo.insert!
