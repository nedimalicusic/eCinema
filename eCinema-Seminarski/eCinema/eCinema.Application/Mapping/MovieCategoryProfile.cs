using eCinema.Core;
using eCinema.Core.Entities;

namespace eCinema.Application.Mapping
{
    public class MovieCategoryProfile : BaseProfile
    {
        public MovieCategoryProfile()
        {
            CreateMap<MovieCategoryDto, MovieCategory>().ReverseMap();

            CreateMap<MovieCategoryUpsertDto, MovieCategory>();
        }
    }
}
