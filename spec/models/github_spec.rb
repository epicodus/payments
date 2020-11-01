describe Github, :vcr do
  it 'updates code review content based on Github repo name & list of file paths' do
    code_review = FactoryBot.create(:code_review, github_path: "https://github.com/#{ENV['GITHUB_CURRICULUM_ORGANIZATION']}/testing/blob/master/README.md")
    Github.update_code_reviews({ repo: 'testing', modified: ['README.md'], removed: [] })
    expect(code_review.reload.content).to include 'testing'
  end

  it 'clears code review content when removed from Github repo' do
    code_review = FactoryBot.create(:code_review, github_path: "https://github.com/#{ENV['GITHUB_CURRICULUM_ORGANIZATION']}/testing/blob/master/README.md")
    Github.update_code_reviews({ repo: 'testing', modified: [], removed: ['README.md'] })
    expect(code_review.reload.content).to eq ''
  end

  it 'updates content for multiple code reviews' do
    code_review_1 = FactoryBot.create(:code_review, github_path: "https://github.com/#{ENV['GITHUB_CURRICULUM_ORGANIZATION']}/testing/blob/master/README.md")
    code_review_2 = FactoryBot.create(:code_review, github_path: "https://github.com/#{ENV['GITHUB_CURRICULUM_ORGANIZATION']}/testing/blob/master/README.md")
    Github.update_code_reviews({ repo: 'testing', modified: ['README.md'], removed: [] })
    expect(code_review_1.reload.content).to include 'testing'
    expect(code_review_2.reload.content).to include 'testing'
  end

  it 'clears content for multiple code reviews' do
    code_review_1 = FactoryBot.create(:code_review, github_path: "https://github.com/#{ENV['GITHUB_CURRICULUM_ORGANIZATION']}/testing/blob/master/README.md")
    code_review_2 = FactoryBot.create(:code_review, github_path: "https://github.com/#{ENV['GITHUB_CURRICULUM_ORGANIZATION']}/testing/blob/master/README.md")
    Github.update_code_reviews({ repo: 'testing', modified: [], removed: ['README.md'] })
    expect(code_review_1.reload.content).to include ''
    expect(code_review_2.reload.content).to include ''
  end

  it 'fetches code review content from Github given github_path' do
    github_path = "https://github.com/#{ENV['GITHUB_CURRICULUM_ORGANIZATION']}/testing/blob/master/README.md"
    expect(Github.get_content(github_path)[:content]).to include 'testing'
  end

  xit 'gets layout params based on layout file path' do
    layout_file_path = "https://github.com/#{ENV['GITHUB_CURRICULUM_ORGANIZATION']}/testing/blob/master/pt_intro_layout.yaml"
    expect(Github.get_layout_params(layout_file_path).values).to include 23
  end

  it 'returns an error when unable to retrieve layout file from Github' do
    allow(Github).to receive(:get_content).and_return({error: true})
    layout_file_path = "https://github.com/#{ENV['GITHUB_CURRICULUM_ORGANIZATION']}/testing/blob/master/pt_intro_layout.yaml"
    expect { Github.get_layout_params(layout_file_path) }.to raise_error UncaughtThrowError
  end
end
