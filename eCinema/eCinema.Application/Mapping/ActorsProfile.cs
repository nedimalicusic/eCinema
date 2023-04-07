using eCinema.Core;

namespace eCinema.Application
{
    public class ActorsProfile : BaseProfile
    {
        public ActorsProfile()
        {
            CreateMap<ActorsDto, Actors>().ReverseMap();

            CreateMap<ActorsUpsertDto, Actors>();
        }
    }
}
