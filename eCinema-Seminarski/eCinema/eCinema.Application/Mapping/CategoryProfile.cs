using eCinema.Core.Entities;
using eCinema.Core;

namespace eCinema.Application.Mapping
{
    public class CategoryProfile : BaseProfile
    {
        public CategoryProfile()
        {
            CreateMap<CategoryDto, Category>();
            CreateMap<Category, CategoryDto>()
                 .ForMember(x => x.Movies, options => options.MapFrom(y => y.MovieCategories.Select(z => z.Movie)));

            CreateMap<CategoryUpsertDto, Category>();
        }
    }
}
