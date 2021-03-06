class GithubCallback
  include ActiveModel::Model

  attr_reader :event

  def initialize(params)
    @event = params
  end

  def update_code_reviews
    Github.update_code_reviews({ repo: repo, modified: files_modified, removed: files_removed })
  end

  def push_to_main?
    branch == 'refs/heads/main'
  end

private

  def branch
    event['ref']
  end

  def repo
    event['repository']['name']
  end

  def files_modified
    event['commits'].map { |commit| commit['added'] + commit['modified'] }.flatten.uniq
  end

  def files_removed
    event['commits'].map { |commit| commit['removed'] }.flatten.uniq
  end
end
