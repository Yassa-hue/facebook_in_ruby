

class Comment

  @@next_id = 0

  attr_accessor :id, :writer_name, :body

  def initialize (writer_name, body)
    @id, @writer_name, @body = @@next_id, writer_name, body
    @@next_id += 1
  end

  def to_s
    "##{@id} #{@writer_name} : #{@body}"
  end
end



class Post
  @@next_id = 0
  attr_accessor :id, :writer_name, :body

  def initialize (writer_name, body)
    @id, @writer_name, @body = @@next_id, writer_name, body
    @comments = []
    @@next_id += 1
  end

  def to_s
    "##{@id} #{@writer_name}\n   #{@body}"
  end

  def [](comment_index)
    @comments[comment_index]
  end

  def add_comment! (comment_writer, comment_body)
    if comment
      @comments << Comment.new(comment_writer, comment_body)
    end
  end

  def each_comment
    @comments.each { |comment| yield comment }
  end
end



class User
  @@next_id = 0
  attr_accessor :id, :name, :password
  def User.new (name, password)
    @id, @name, @password = @@next_id, name, password
    @posts = []
    @@next_id += 1
  end

  def name
    @name
  end

  def password
    @password
  end

  def each_post
    @posts.each { |post| yield post }
  end

  def add_post! (post_body)
    @posts << Post.new( @name, post_body )
  end


  def [] (post_index)
    @posts[post_index]
  end


  def to_s
    "##{@id} User name : #{@name}"
  end

end




class Program
  def initialize
    @users = []

    @cur_user = self.auth_screen!

    while true
      ch = self.home_screen!
      if ch == -1
        break
      end
    end
  end

  def login
    # get the username and password from user
    username = gets
    password = gets

    # search for the user in the users
    @users.select {|user| user.name == username && user.password == password}[0]
  end

  def signup!
    # get the username and password from user
    username = gets
    password = gets

    # add new user to users
    @users << User.new(username, password)
    @users[-1]
  end

  def auth_screen!
    puts "1 ) Login"
    puts "2 ) signup"

    user_choice = gets

    if user_choice == "1"
      login
    else
      signup!
    end
  end


  def home_screen!
    puts "1 ) Show my data"
    puts "2 ) Show all posts"
    puts "3 ) Show specific post"
    puts "4 ) Post an idea"
    puts "5 ) Comment on a post"


    user_choice = gets
    user_choice = user_choice[0...-1]

    puts "You entered #{user_choice} class #{user_choice.class}"

    case user_choice
      when "1"
        puts @cur_user
      when "2"
        @users.each { |user| user.each_post {|post| puts post} }
      when "3"
        post_id = gets

        # get the post from the user
        post = get_post post_id.to_i

        # print post with comments
        if post
          puts post
          post.each_comment {|comment| puts comment}
        else
          puts "No post with this id"
        end
      when "4"
        post_body = gets
        @cur_user.add_post! post_body
      when "5"
        post_id = gets
        post = get_post post_id.to_i

        if post
          comment_body = gets
          post.add_comment! @cur_user.name, comment_body
        else
          puts "No post with this id"
        end
      else
        puts "exit program"
        -1
    end


  end


  def get_post (post_id)
    @users.each { |user| user.each_post { |post| return post if post.id == post_id } }
    nil
  end


end


p = Program.new

