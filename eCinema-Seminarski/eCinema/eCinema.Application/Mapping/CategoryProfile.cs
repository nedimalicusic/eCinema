using eCinema.Core.Entities;
using eCinema.Core;

namespace eCinema.Application.Mapping
{
    public class CategoryProfile : BaseProfile
    {
        public CategoryProfile()
        {
            CreateMap<CategoryDto, Category>().ReverseMap();

            CreateMap<CategoryUpsertDto, Category>();
        }
    }
}
