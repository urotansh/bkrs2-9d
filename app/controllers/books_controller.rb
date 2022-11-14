class BooksController < ApplicationController
before_action :is_matching_login_user, only: [:edit, :update]

  def show
    @book_new = Book.new
    @book = Book.find(params[:id])
    @book_comment = BookComment.new
  end

  def index
    @book = Book.new
    if params[:order_updated_desc]
      @books = Book.order_updated_desc
    elsif params[:order_rate_desc]
      @books = Book.order_rate_desc
    else
      @books = Book.all
    end
    
  end

  def create
    @book = Book.new(book_params)
    @book.user_id = current_user.id
    @book.rate = book_rate_params[:rate] unless book_rate_params[:rate].empty?
    if @book.save
      redirect_to book_path(@book), notice: "You have created book successfully."
    else
      @books = Book.all
      render 'index'
    end
  end

  def edit
    @book = Book.find(params[:id])
  end

  def update
    @book = Book.find(params[:id])
    if @book.update(book_params)
      redirect_to book_path(@book), notice: "You have updated book successfully."
    else
      render "edit"
    end
  end

  def destroy
    @book = Book.find(params[:id])
    @book.destroy
    redirect_to books_path
  end

  private

  def book_params
    params.require(:book).permit(:title, :body, :tag)
  end
  
  def book_rate_params
    params.permit(:rate)
  end
  
  def is_matching_login_user
    user_id = Book.find(params[:id]).user.id.to_i
    login_user_id = current_user.id
    if(user_id != login_user_id)
      redirect_to books_path
    end
  end
end
