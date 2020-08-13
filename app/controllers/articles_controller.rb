class ArticlesController < InheritedResources::Base

  private

    def article_params
      params.require(:article).permit(:title, :content, :user_id)
    end

end
